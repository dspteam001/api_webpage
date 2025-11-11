import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_BASE_URL = 'http://localhost:8000';

function App() {
  const [method, setMethod] = useState('GET');
  const [url, setUrl] = useState('');
  const [headers, setHeaders] = useState('');
  const [body, setBody] = useState('');
  const [response, setResponse] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [history, setHistory] = useState([]);

  useEffect(() => {
    fetchHistory();
    // Load example on first visit
    if (!url) {
      loadExample();
    }
  }, []);

  const loadExample = () => {
    setMethod('GET');
    setUrl('https://jsonplaceholder.typicode.com/users/1');
    setHeaders(JSON.stringify({
      "Accept": "application/json"
    }, null, 2));
  };

  const fetchHistory = async () => {
    try {
      const res = await axios.get(`${API_BASE_URL}/api/history`);
      setHistory(res.data);
    } catch (err) {
      console.error('Failed to fetch history:', err);
    }
  };

  const handleSendRequest = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setResponse(null);

    try {
      // Parse headers
      let parsedHeaders = {};
      if (headers.trim()) {
        try {
          parsedHeaders = JSON.parse(headers);
        } catch (e) {
          throw new Error('Invalid JSON in headers');
        }
      }

      const requestData = {
        method,
        url,
        headers: parsedHeaders,
        body: body.trim() || null
      };

      const res = await axios.post(`${API_BASE_URL}/api/request`, requestData);
      setResponse(res.data);
      fetchHistory(); // Refresh history
    } catch (err) {
      setError(err.response?.data?.detail || err.message || 'Request failed');
    } finally {
      setLoading(false);
    }
  };

  const handleHistoryClick = async (requestId) => {
    try {
      const res = await axios.get(`${API_BASE_URL}/api/history/${requestId}`);
      const detail = res.data;

      setMethod(detail.method);
      setUrl(detail.url);
      setHeaders(JSON.stringify(detail.headers, null, 2));
      setBody(detail.body || '');

      setResponse({
        status_code: detail.response_status,
        body: detail.response_body,
        response_time: detail.response_time,
        headers: {}
      });
    } catch (err) {
      console.error('Failed to load request details:', err);
    }
  };

  const getStatusClass = (status) => {
    if (status >= 200 && status < 300) return 'status-200';
    if (status >= 300 && status < 400) return 'status-300';
    if (status >= 400 && status < 500) return 'status-400';
    return 'status-500';
  };

  const formatResponseBody = (body) => {
    try {
      const parsed = JSON.parse(body);
      return JSON.stringify(parsed, null, 2);
    } catch {
      return body;
    }
  };

  return (
    <div className="App">
      <header className="header">
        <h1>API Tester</h1>
        <p>Test your API</p>
      </header>

      <div className="main-content">
        <div className="request-panel">
          <h2 className="section-title">
            Request
            <span className="example-badge" onClick={loadExample} style={{cursor: 'pointer'}}>
              Load Example
            </span>
          </h2>

          <form onSubmit={handleSendRequest}>
            <div className="form-group">
              <label>
                URL <span className="required-mark">*</span>
              </label>
              <div className="url-input-group">
                <select
                  className="method-select"
                  value={method}
                  onChange={(e) => setMethod(e.target.value)}
                >
                  <option value="GET">GET</option>
                  <option value="POST">POST</option>
                  <option value="PUT">PUT</option>
                  <option value="DELETE">DELETE</option>
                  <option value="PATCH">PATCH</option>
                </select>
                <input
                  type="text"
                  className="url-input"
                  placeholder="https://api.example.com/endpoint"
                  value={url}
                  onChange={(e) => setUrl(e.target.value)}
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label>
                Headers
                <span style={{fontSize: '12px', color: '#6b7280', fontWeight: 400, marginLeft: '8px'}}>
                  (JSON format)
                </span>
              </label>
              <textarea
                className="textarea"
                placeholder={'{\n  "Content-Type": "application/json",\n  "Authorization": "Bearer your-token"\n}'}
                value={headers}
                onChange={(e) => setHeaders(e.target.value)}
              />
            </div>

            {(method === 'POST' || method === 'PUT' || method === 'PATCH') && (
              <div className="form-group">
                <label>
                  Body
                  <span style={{fontSize: '12px', color: '#6b7280', fontWeight: 400, marginLeft: '8px'}}>
                    (JSON or text)
                  </span>
                </label>
                <textarea
                  className="textarea"
                  placeholder={'{\n  "name": "John Doe",\n  "email": "john@example.com"\n}'}
                  value={body}
                  onChange={(e) => setBody(e.target.value)}
                  style={{ minHeight: '180px' }}
                />
              </div>
            )}

            <button
              type="submit"
              className="send-button"
              disabled={loading}
            >
              {loading ? '⏳ Sending...' : '🚀 Send Request'}
            </button>
          </form>

          {error && (
            <div className="error-message">
              <strong>❌ Error:</strong> {error}
            </div>
          )}

          {response && (
            <div className="response-section">
              <h3>📥 Response</h3>
              <div className="response-meta">
                <div className="response-meta-item">
                  <span className="response-meta-label">Status Code</span>
                  <span className={`response-meta-value ${getStatusClass(response.status_code)}`}>
                    {response.status_code}
                  </span>
                </div>
                <div className="response-meta-item">
                  <span className="response-meta-label">Response Time</span>
                  <span className="response-meta-value" style={{color: '#6366f1'}}>
                    {response.response_time}ms
                  </span>
                </div>
                <div className="response-meta-item">
                  <span className="response-meta-label">Size</span>
                  <span className="response-meta-value" style={{color: '#8b5cf6'}}>
                    {new Blob([response.body]).size} B
                  </span>
                </div>
              </div>
              <div className="form-group">
                <label style={{marginBottom: '12px'}}>Response Body</label>
                <pre className="response-body">
                  {formatResponseBody(response.body)}
                </pre>
              </div>
            </div>
          )}
        </div>

        <div className="history-panel">
          <h2>History</h2>
          {history.length === 0 ? (
            <p style={{ color: '#999', textAlign: 'center', marginTop: '20px' }}>
              No requests yet
            </p>
          ) : (
            history.map((item) => (
              <div
                key={item.id}
                className="history-item"
                onClick={() => handleHistoryClick(item.id)}
              >
                <div>
                  <span className={`history-method method-${item.method}`}>
                    {item.method}
                  </span>
                  <span className={getStatusClass(item.response_status)}>
                    {item.response_status}
                  </span>
                </div>
                <div className="history-url">{item.url}</div>
                <div className="history-time">
                  {item.response_time}ms • {new Date(item.created_at).toLocaleString()}
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
