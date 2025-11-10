import { useState, useEffect } from 'react';
import { llmAPI } from '../services/api';

function RequestList({ refresh }) {
  const [requests, setRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [selectedRequest, setSelectedRequest] = useState(null);

  useEffect(() => {
    loadRequests();
  }, [refresh]);

  const loadRequests = async () => {
    try {
      setLoading(true);
      const data = await llmAPI.getAllRequests();
      setRequests(data);
      setError('');
    } catch (err) {
      setError('요청 목록을 불러오는 중 오류가 발생했습니다.');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (requestId) => {
    if (!window.confirm('이 요청을 삭제하시겠습니까?')) {
      return;
    }

    try {
      await llmAPI.deleteRequest(requestId);
      loadRequests();
      if (selectedRequest?.id === requestId) {
        setSelectedRequest(null);
      }
    } catch (err) {
      alert('삭제 중 오류가 발생했습니다.');
    }
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleString('ko-KR');
  };

  const getStatusBadge = (status) => {
    const statusMap = {
      completed: { text: '완료', class: 'status-completed' },
      processing: { text: '처리중', class: 'status-processing' },
      failed: { text: '실패', class: 'status-failed' },
      pending: { text: '대기', class: 'status-pending' },
    };
    const statusInfo = statusMap[status] || { text: status, class: '' };
    return <span className={`status-badge ${statusInfo.class}`}>{statusInfo.text}</span>;
  };

  if (loading) {
    return <div className="loading">로딩 중...</div>;
  }

  if (error) {
    return <div className="error-message">{error}</div>;
  }

  return (
    <div className="request-list-container">
      <h2>요청 기록</h2>
      {requests.length === 0 ? (
        <p className="no-requests">아직 요청 기록이 없습니다.</p>
      ) : (
        <div className="request-list">
          {requests.map((request) => (
            <div
              key={request.id}
              className={`request-item ${selectedRequest?.id === request.id ? 'selected' : ''}`}
              onClick={() => setSelectedRequest(request)}
            >
              <div className="request-header">
                <span className="request-id">#{request.id}</span>
                {getStatusBadge(request.status)}
                <span className="request-date">{formatDate(request.created_at)}</span>
              </div>
              <div className="request-info">
                <div><strong>모델:</strong> {request.model_name}</div>
                <div><strong>API:</strong> {request.api_url}</div>
                {request.file_name && (
                  <div><strong>파일:</strong> {request.file_name}</div>
                )}
              </div>
              {request.prompt && (
                <div className="request-prompt">
                  <strong>프롬프트:</strong> {request.prompt.substring(0, 100)}
                  {request.prompt.length > 100 ? '...' : ''}
                </div>
              )}
              {request.response && (
                <div className="request-response">
                  <strong>응답:</strong> {request.response.substring(0, 150)}
                  {request.response.length > 150 ? '...' : ''}
                </div>
              )}
              {request.error_message && (
                <div className="request-error">
                  <strong>에러:</strong> {request.error_message}
                </div>
              )}
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  handleDelete(request.id);
                }}
                className="delete-button"
              >
                삭제
              </button>
            </div>
          ))}
        </div>
      )}

      {selectedRequest && (
        <div className="request-detail-modal" onClick={() => setSelectedRequest(null)}>
          <div className="request-detail" onClick={(e) => e.stopPropagation()}>
            <button className="close-button" onClick={() => setSelectedRequest(null)}>×</button>
            <h3>요청 상세 정보</h3>
            <div className="detail-content">
              <div><strong>ID:</strong> {selectedRequest.id}</div>
              <div><strong>상태:</strong> {getStatusBadge(selectedRequest.status)}</div>
              <div><strong>모델:</strong> {selectedRequest.model_name}</div>
              <div><strong>API 주소:</strong> {selectedRequest.api_url}</div>
              <div><strong>생성일:</strong> {formatDate(selectedRequest.created_at)}</div>
              {selectedRequest.file_name && (
                <div><strong>첨부파일:</strong> {selectedRequest.file_name}</div>
              )}
              {selectedRequest.prompt && (
                <div className="detail-section">
                  <strong>프롬프트:</strong>
                  <pre>{selectedRequest.prompt}</pre>
                </div>
              )}
              {selectedRequest.response && (
                <div className="detail-section">
                  <strong>응답:</strong>
                  <pre>{selectedRequest.response}</pre>
                </div>
              )}
              {selectedRequest.error_message && (
                <div className="detail-section error">
                  <strong>에러 메시지:</strong>
                  <pre>{selectedRequest.error_message}</pre>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default RequestList;
