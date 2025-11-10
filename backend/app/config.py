from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    app_name: str = "LLM API WebApp"
    debug: bool = True
    api_version: str = "v1"
    database_url: str
    cors_origins: List[str] = ["http://localhost:3000", "http://localhost:5173"]
    upload_dir: str = "./uploads"
    max_upload_size: int = 10485760  # 10MB

    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()
