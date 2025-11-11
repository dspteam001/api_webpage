from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional, Dict, List
import httpx
import json
import time
from database import engine, get_db, Base
from models import APIRequest

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="API Tester")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class APIRequestModel(BaseModel):
    method: str
    url: str
    headers: Optional[Dict[str, str]] = None
    body: Optional[str] = None

class APIResponseModel(BaseModel):
    status_code: int
    headers: Dict[str, str]
    body: str
    response_time: int

@app.get("/")
async def root():
    return {"message": "API Tester Backend is running"}

@app.post("/api/request", response_model=APIResponseModel)
async def make_request(request: APIRequestModel, db: Session = Depends(get_db)):
    """
    Make an API request and save it to the database
    """
    try:
        start_time = time.time()

        # Prepare headers
        headers = request.headers or {}

        # Make the request
        async with httpx.AsyncClient(timeout=30.0) as client:
            if request.method.upper() == "GET":
                response = await client.get(request.url, headers=headers)
            elif request.method.upper() == "POST":
                response = await client.post(
                    request.url,
                    headers=headers,
                    content=request.body if request.body else None
                )
            elif request.method.upper() == "PUT":
                response = await client.put(
                    request.url,
                    headers=headers,
                    content=request.body if request.body else None
                )
            elif request.method.upper() == "DELETE":
                response = await client.delete(request.url, headers=headers)
            elif request.method.upper() == "PATCH":
                response = await client.patch(
                    request.url,
                    headers=headers,
                    content=request.body if request.body else None
                )
            else:
                raise HTTPException(status_code=400, detail="Unsupported HTTP method")

        end_time = time.time()
        response_time = int((end_time - start_time) * 1000)

        # Save to database
        db_request = APIRequest(
            method=request.method.upper(),
            url=request.url,
            headers=json.dumps(request.headers) if request.headers else None,
            body=request.body,
            response_status=response.status_code,
            response_body=response.text,
            response_time=response_time
        )
        db.add(db_request)
        db.commit()

        return APIResponseModel(
            status_code=response.status_code,
            headers=dict(response.headers),
            body=response.text,
            response_time=response_time
        )

    except httpx.RequestError as e:
        raise HTTPException(status_code=500, detail=f"Request failed: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")

@app.get("/api/history")
async def get_history(db: Session = Depends(get_db), limit: int = 50):
    """
    Get request history
    """
    requests = db.query(APIRequest).order_by(APIRequest.created_at.desc()).limit(limit).all()
    return [
        {
            "id": req.id,
            "method": req.method,
            "url": req.url,
            "response_status": req.response_status,
            "response_time": req.response_time,
            "created_at": req.created_at.isoformat()
        }
        for req in requests
    ]

@app.get("/api/history/{request_id}")
async def get_request_detail(request_id: int, db: Session = Depends(get_db)):
    """
    Get detailed information about a specific request
    """
    request = db.query(APIRequest).filter(APIRequest.id == request_id).first()
    if not request:
        raise HTTPException(status_code=404, detail="Request not found")

    return {
        "id": request.id,
        "method": request.method,
        "url": request.url,
        "headers": json.loads(request.headers) if request.headers else {},
        "body": request.body,
        "response_status": request.response_status,
        "response_body": request.response_body,
        "response_time": request.response_time,
        "created_at": request.created_at.isoformat()
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
