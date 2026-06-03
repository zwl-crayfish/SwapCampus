import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi, userApi } from '@/api'

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))

  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 1)

  async function login(username, password) {
    const res = await authApi.login({ username, password })
    token.value = res.data.accessToken
    user.value = {
      id: res.data.userId,
      username: res.data.username,
      realName: res.data.realName,
      avatarUrl: res.data.avatarUrl,
      role: res.data.role,
    }
    localStorage.setItem('token', token.value)
    localStorage.setItem('user', JSON.stringify(user.value))
  }

  async function register(data) {
    const res = await authApi.register(data)
    token.value = res.data.accessToken
    user.value = {
      id: res.data.userId,
      username: res.data.username,
      realName: res.data.realName,
      avatarUrl: res.data.avatarUrl,
      role: res.data.role,
    }
    localStorage.setItem('token', token.value)
    localStorage.setItem('user', JSON.stringify(user.value))
  }

  function logout() {
    token.value = ''
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  async function fetchProfile() {
    if (!token.value) return
    try {
      const res = await userApi.getMe()
      user.value = res.data
      localStorage.setItem('user', JSON.stringify(res.data))
    } catch {
      logout()
    }
  }

  return { token, user, isLoggedIn, isAdmin, login, register, logout, fetchProfile }
})
