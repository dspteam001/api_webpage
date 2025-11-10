import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const llmAPI = {
  // LLM API 요청 생성
  createRequest: async (formData) => {
    const response = await axios.post(`${API_URL}/api/llm/request`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data;
  },

  // 모든 요청 조회
  getAllRequests: async (skip = 0, limit = 100) => {
    const response = await api.get(`/api/llm/requests?skip=${skip}&limit=${limit}`);
    return response.data;
  },

  // 특정 요청 조회
  getRequest: async (requestId) => {
    const response = await api.get(`/api/llm/requests/${requestId}`);
    return response.data;
  },

  // 요청 삭제
  deleteRequest: async (requestId) => {
    const response = await api.delete(`/api/llm/requests/${requestId}`);
    return response.data;
  },
};

export default api;
