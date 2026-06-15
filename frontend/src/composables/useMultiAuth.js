/**
 * 多账号会话管理模块
 * 支持同一浏览器登录多个账号，通过 localStorage 隔离各账号的 token 和用户信息
 *
 * 存储结构:
 *   sc_sessions: [{ id, username, realName, avatarUrl, role, token, loginTime }]
 *   sc_active_session_id: 当前活跃的 session id
 */

const SESSIONS_KEY = 'sc_sessions'
const ACTIVE_ID_KEY = 'sc_active_session_id'

/** 读取所有会话 */
function _readSessions() {
  try {
    return JSON.parse(localStorage.getItem(SESSIONS_KEY) || '[]')
  } catch {
    return []
  }
}

/** 写入所有会话 */
function _writeSessions(sessions) {
  localStorage.setItem(SESSIONS_KEY, JSON.stringify(sessions))
}

/** 获取当前活跃会话 ID */
function getActiveId() {
  return localStorage.getItem(ACTIVE_ID_KEY) || ''
}

/** 设置当前活跃会话 ID */
function setActiveId(id) {
  if (id) {
    localStorage.setItem(ACTIVE_ID_KEY, id)
  } else {
    localStorage.removeItem(ACTIVE_ID_KEY)
  }
}

/**
 * 迁移旧格式数据（token/user）到新多账号格式
 * 只在旧数据存在且新数据为空时执行一次
 */
export function migrateOldAuthData() {
  const oldToken = localStorage.getItem('token')
  const oldUserStr = localStorage.getItem('user')

  // 有旧数据且新数据为空时才迁移
  if (oldToken && oldUserStr && _readSessions().length === 0) {
    try {
      const oldUser = JSON.parse(oldUserStr)
      const session = {
        id: String(oldUser.id),
        userId: oldUser.id,
        username: oldUser.username,
        realName: oldUser.realName || '',
        avatarUrl: oldUser.avatarUrl || '',
        role: oldUser.role || 0,
        token: oldToken,
        loginTime: Date.now(),
      }
      _writeSessions([session])
      setActiveId(session.id)
      // 清除旧格式数据，避免混淆
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    } catch {
      // 解析失败则忽略
    }
  }
}

// ========== 对外 API ==========

/** 获取当前活跃会话（token + 用户信息） */
export function getActiveSession() {
  const sessions = _readSessions()
  const activeId = getActiveId()
  return sessions.find(s => s.id === activeId) || null
}

/** 获取当前活跃 token */
export function getToken() {
  const s = getActiveSession()
  return s ? s.token : ''
}

/** 获取当前活跃用户信息 */
export function getUser() {
  const s = getActiveSession()
  if (!s) return null
  return { id: Number(s.id), username: s.username, realName: s.realName, avatarUrl: s.avatarUrl, role: s.role }
}

/** 是否已登录 */
export function isLoggedIn() {
  return !!getToken()
}

/** 是否为管理员 */
export function isAdmin() {
  const s = getActiveSession()
  return s ? s.role === 1 : false
}

/** 获取所有已登录会话列表（用于切换器） */
export function getAllSessions() {
  return _readSessions()
}

/** 会话数量 */
export function getSessionCount() {
  return _readSessions().length
}

/**
 * 添加/更新一个会话并设为活跃
 * @param {{ userId, username, realName, avatarUrl, role, accessToken }} data 登录返回数据
 * @returns {string} sessionId
 */
export function addSession(data) {
  const sessions = _readSessions()
  // 用 userId 作为 session 的唯一标识，同一用户重复登录只更新 token
  const idx = sessions.findIndex(s => s.userId === data.userId)
  const session = {
    id: String(data.userId),
    userId: data.userId,
    username: data.username,
    realName: data.realName || '',
    avatarUrl: data.avatarUrl || '',
    role: data.role || 0,
    token: data.accessToken,
    loginTime: Date.now(),
  }
  if (idx >= 0) {
    sessions[idx] = session
  } else {
    sessions.push(session)
  }
  _writeSessions(sessions)
  setActiveId(session.id)
  return session.id
}

/** 切换到指定会话 */
export function switchSession(sessionId) {
  const sid = String(sessionId)
  const sessions = _readSessions()
  if (sessions.some(s => s.id === sid)) {
    setActiveId(sid)
    return true
  }
  return false
}

/** 移除指定会话，自动切换到下一个可用会话 */
export function removeSession(sessionId) {
  const sid = String(sessionId)
  let sessions = _readSessions()
  sessions = sessions.filter(s => s.id !== sid)
  _writeSessions(sessions)

  // 如果移除的是当前活跃会话，切换到剩余的第一个
  if (getActiveId() === sid) {
    if (sessions.length > 0) {
      setActiveId(sessions[0].id)
    } else {
      setActiveId('')
    }
  }

  return sessions.length > 0
}

/** 清除所有会话（完全登出） */
export function clearAllSessions() {
  localStorage.removeItem(SESSIONS_KEY)
  localStorage.removeItem(ACTIVE_ID_KEY)
}
