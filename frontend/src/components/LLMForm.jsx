import { useState } from 'react';
import { llmAPI } from '../services/api';

function LLMForm({ onRequestComplete }) {
  const [formData, setFormData] = useState({
    apiUrl: '',
    modelKey: '',
    modelName: '',
    prompt: '',
  });
  const [file, setFile] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleFileChange = (e) => {
    setFile(e.target.files[0]);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const data = new FormData();
      data.append('api_url', formData.apiUrl);
      data.append('model_key', formData.modelKey);
      data.append('model_name', formData.modelName);
      data.append('prompt', formData.prompt);

      if (file) {
        data.append('file', file);
      }

      const result = await llmAPI.createRequest(data);

      // 폼 초기화
      setFormData({
        apiUrl: '',
        modelKey: '',
        modelName: '',
        prompt: '',
      });
      setFile(null);

      if (onRequestComplete) {
        onRequestComplete(result);
      }
    } catch (err) {
      setError(err.response?.data?.detail || err.message || '요청 처리 중 오류가 발생했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="llm-form-container">
      <h2>LLM API 요청</h2>
      <form onSubmit={handleSubmit} className="llm-form">
        <div className="form-group">
          <label htmlFor="apiUrl">API 주소 *</label>
          <input
            type="url"
            id="apiUrl"
            name="apiUrl"
            value={formData.apiUrl}
            onChange={handleInputChange}
            placeholder="https://api.openai.com/v1/chat/completions"
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="modelKey">모델 키/토큰 *</label>
          <input
            type="password"
            id="modelKey"
            name="modelKey"
            value={formData.modelKey}
            onChange={handleInputChange}
            placeholder="sk-..."
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="modelName">모델 선택 *</label>
          <select
            id="modelName"
            name="modelName"
            value={formData.modelName}
            onChange={handleInputChange}
            required
          >
            <option value="">모델을 선택하세요</option>
            <option value="gpt-4">GPT-4</option>
            <option value="gpt-4-turbo">GPT-4 Turbo</option>
            <option value="gpt-3.5-turbo">GPT-3.5 Turbo</option>
            <option value="claude-3-opus">Claude 3 Opus</option>
            <option value="claude-3-sonnet">Claude 3 Sonnet</option>
            <option value="claude-3-haiku">Claude 3 Haiku</option>
            <option value="gemini-pro">Gemini Pro</option>
          </select>
        </div>

        <div className="form-group">
          <label htmlFor="prompt">프롬프트</label>
          <textarea
            id="prompt"
            name="prompt"
            value={formData.prompt}
            onChange={handleInputChange}
            placeholder="질문이나 지시사항을 입력하세요..."
            rows="4"
          />
        </div>

        <div className="form-group">
          <label htmlFor="file">첨부파일</label>
          <input
            type="file"
            id="file"
            onChange={handleFileChange}
            accept="*/*"
          />
          {file && <span className="file-name">{file.name}</span>}
        </div>

        {error && <div className="error-message">{error}</div>}

        <button type="submit" disabled={loading} className="submit-button">
          {loading ? '처리 중...' : 'API 요청 전송'}
        </button>
      </form>
    </div>
  );
}

export default LLMForm;
