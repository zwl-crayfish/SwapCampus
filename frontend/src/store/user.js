import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi, userApi } from '@/api'
import {
  getToken, getUser,
  addSession, removeSession, switchSession,
  getAllSessions, getSessionCount, clearAllSessions,
  migrateOldAuthData
} from '@/composables/useMultiAuth'

export const useUserStore = defineStore('user', () => {
  // 首次加载时，将旧格式登录数据迁移到新多账号格式
  migrateOldAuthData()

  const token = ref(getToken())
  const user = ref(getUser())

  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 1)

  /** 刷新 store 状态（从多账号模块同步） */
  function _sync() {
    token.value = getToken()
    user.value = getUser()
  }

  // 监听其他标签页对 localStorage 的修改，自动同步 store 状态
  if (typeof window !== 'undefined') {
    window.addEventListener('storage', (e) => {
      if (e.key === 'sc_sessions' || e.key === 'sc_active_session_id') {
        _sync()
      }
    })
  }

  async function login(username, password) {
    const res = await authApi.login({ username, password })
    addSession(res)
    _sync()
  }

  async function register(data) {
    const res = await authApi.register(data)
    addSession(res)
    _sync()
  }

  /** 退出当前账号（只移除当前会话，保留其他账号） */
  function logout() {
    if (user.value?.id) {
      removeSession(user.value.id)
    } else {
      // 兜底：如果用户信息异常，直接清除全部
      clearAllSessions()
    }
    _sync()
  }

  /** 完全退出所有账号 */
  function logoutAll() {
    clearAllSessions()
    _sync()
  }

  /** 切换到指定账号 */
  function switchAccount(sessionId) {
    if (switchSession(sessionId)) {
      _sync()
      return true
    }
    return false
  }

  async function fetchProfile() {
    if (!token.value) return
    try {
      const res = await userApi.getMe()
      // 更新当前会话的用户信息（不改变 token）
      user.value = res
    } catch {
      logout()
    }
  }

  return {
    token, user, isLoggedIn, isAdmin,
    login, register, logout, logoutAll, switchAccount, fetchProfile,
    // 暴露多账号相关方法给组件使用
    getAllSessions, getSessionCount,
  }
})
