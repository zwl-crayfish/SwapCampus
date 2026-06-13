import axios from 'axios'
import { ElMessage } from 'element-plus'

const http = axios.create({
  baseURL: '/api',
  timeout: 15000,
})

// 请求拦截器
http.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截器
http.interceptors.response.use(
  (response) => {
    const { code, message, data } = response.data
    if (code === 200) {
      return data !== undefined ? data : response.data
    }
    ElMessage.error(message || '请求失败')
    return Promise.reject(new Error(message))
  },
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }
    ElMessage.error(error.response?.data?.message || '网络错误')
    return Promise.reject(error)
  }
)

// Auth API
export const authApi = {
  login: (data) => http.post('/auth/login', data),
  register: (data) => http.post('/auth/register', data),
}

// User API
export const userApi = {
  getMe: () => http.get('/users/me'),
  getProfile: (id) => http.get(`/users/${id}`),
  updateProfile: (data) => http.put('/users/me', data),
}

// Goods API
export const goodsApi = {
  list: (params) => http.get('/goods/list', { params }),
  detail: (uuid) => http.get(`/goods/detail/${uuid}`),
  publish: (formData) => http.post('/goods/publish', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  }),
  update: (uuid, formData) => http.put(`/goods/${uuid}`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  }),
  changeStatus: (uuid, status) => http.put(`/goods/${uuid}/status`, null, { params: { status } }),
  toggleFavorite: (uuid) => http.post(`/goods/${uuid}/favorite`),
  myPublished: (params) => http.get('/goods/my-published', { params }),
}

// Order API
export const orderApi = {
  create: (params) => http.post('/orders', null, { params }),
  detail: (uuid) => http.get(`/orders/${uuid}`),
  buyerConfirm: (uuid) => http.put(`/orders/${uuid}/buyer-confirm`),
  sellerConfirm: (uuid) => http.put(`/orders/${uuid}/seller-confirm`),
  cancel: (uuid) => http.put(`/orders/${uuid}/cancel`),
  review: (uuid, rating, review) => http.put(`/orders/${uuid}/review`, null, { params: { rating, review } }),
  buyerOrders: (params) => http.get('/orders/buyer', { params }),
  sellerOrders: (params) => http.get('/orders/seller', { params }),
}

// Chat API
export const chatApi = {
  getConversation: (contactId, params) => http.get(`/chat/conversation/${contactId}`, { params }),
  getContacts: (params) => http.get('/chat/contacts', { params }),
}

// Category API
export const categoryApi = {
  list: () => http.get('/category'),
}

// Admin API
export const adminApi = {
  dashboard: () => http.get('/admin/dashboard'),
  getUsers: (params) => http.get('/admin/users', { params }),
  toggleUserStatus: (id, status) => http.put(`/admin/users/${id}/status`, null, { params: { status } }),
  auditGoods: (uuid, status) => http.put(`/admin/goods/${uuid}/audit`, null, { params: { status } }),
  getReports: (params) => http.get('/admin/reports', { params }),
  handleReport: (id, status, remark) => http.put(`/admin/reports/${id}/handle`, null, { params: { status, remark } }),
}

export default http
