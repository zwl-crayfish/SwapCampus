<template>
  <div class="chat-page">
    <div class="chat-container">
      <!-- 左侧联系人列表 -->
      <div class="chat-sidebar">
        <div class="sidebar-header">
          <h2 class="sidebar-title">消息</h2>
        </div>
        <div class="contacts-list">
          <div v-if="contacts.length === 0" class="empty-contacts">
            <div class="empty-icon">💬</div>
            <p>暂无消息</p>
            <span>开始与好友聊天吧~</span>
          </div>
          <div
            v-for="c in contacts"
            :key="c"
            class="contact-item"
            :class="{ active: currentContact === c }"
            @click="openChat(c)"
          >
            <div class="contact-avatar">
              <span>{{ (userNames[c] || '?').charAt(0).toUpperCase() }}</span>
            </div>
            <div class="contact-content">
              <div class="contact-name">{{ userNames[c] || ('用户 #' + c) }}</div>
              <div class="contact-preview">点击开始聊天</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧聊天区 -->
      <div class="chat-main">
        <div v-if="!currentContact" class="chat-placeholder">
          <div class="placeholder-icon">💌</div>
          <h3>选择一个联系人</h3>
          <p>从左侧列表选择联系人开始聊天</p>
        </div>
        <template v-else>
          <!-- 聊天头部 -->
          <div class="chat-header">
            <div class="header-user-info">
              <div class="header-avatar">
                <span>{{ (userNames[currentContact] || '?').charAt(0).toUpperCase() }}</span>
              </div>
              <span class="header-username">{{ userNames[currentContact] || ('用户 #' + currentContact) }}</span>
            </div>
          </div>

          <!-- 消息区域 -->
          <div class="chat-messages" ref="messagesRef">
            <div
              v-for="msg in messages"
              :key="msg.uuid"
              class="message-wrapper"
              :class="{ 'is-self': String(msg.senderId) === String(currentUserId) }"
            >
              <div class="message-item">
                <div v-if="String(msg.senderId) !== String(currentUserId)" class="message-avatar">
                  <span>{{ (userNames[msg.senderId] || '?').charAt(0).toUpperCase() }}</span>
                </div>
                <div class="message-bubble" :class="{ 'bubble-self': String(msg.senderId) === String(currentUserId) }">
                  <div v-if="msg.msgType === 'IMAGE'" class="msg-image">
                    <el-image :src="msg.content" fit="cover" :preview-src-list="[msg.content]" />
                  </div>
                  <div v-else class="msg-text">{{ msg.content }}</div>
                  <div class="msg-time">{{ formatTime(msg.createdAt) }}</div>
                </div>
                <div v-if="String(msg.senderId) === String(currentUserId)" class="message-avatar self-avatar">
                  <span>我</span>
                </div>
              </div>
            </div>
            <div v-if="messages.length === 0 && !loadingMsgs" class="no-msg-hint">
              <span>暂无聊天记录，发送第一条消息吧~</span>
            </div>
          </div>

          <!-- 输入区域 -->
          <div class="chat-input-area">
            <div class="input-toolbar">
              <el-tooltip content="发送图片" placement="top">
                <button class="toolbar-btn" @click="triggerImageUpload">
                  🖼️
                </button>
              </el-tooltip>
              <input ref="fileInputRef" type="file" accept="image/*" style="display:none" @change="handleImageSelect" />
              <el-popover trigger="click" placement="top" :width="280">
                <template #reference>
                  <button class="toolbar-btn">😊</button>
                </template>
                <div class="emoji-grid">
                  <span
                    v-for="(emoji, idx) in emojiList"
                    :key="idx"
                    class="emoji-item"
                    @click="insertEmoji(emoji)"
                  >{{ emoji }}</span>
                </div>
              </el-popover>
            </div>
            <div class="input-box">
              <textarea
                v-model="inputText"
                placeholder="输入消息..."
                rows="1"
                @keyup.enter.exact.prevent="sendText"
              ></textarea>
            </div>
            <button
              class="send-btn"
              :class="{ 'can-send': inputText.trim() }"
              :disabled="!inputText.trim()"
              @click="sendText"
            >
              <span>发送</span>
            </button>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { Picture, Promotion } from '@element-plus/icons-vue'
import { chatApi } from '@/api'
import { ElMessage } from 'element-plus'

const route = useRoute()

// 从 localStorage 获取当前用户ID
const userObj = JSON.parse(localStorage.getItem('user') || '{}')
const currentUserId = userObj?.id

const contacts = ref([])
const messages = ref([])
const currentContact = ref(null)
const inputText = ref('')
const messagesRef = ref(null)
const fileInputRef = ref(null)
const sending = ref(false)
const loadingMsgs = ref(false)

// 用户ID -> 用户名 映射
const userNames = ref({})

// 表情列表（使用数组更稳定）
const emojiList = [
  '\u{1F604}', '\u{1F606}', '\u{1F60D}', '\u{1F622}',
  '\u{1F621}', '\u{1F62E}', '\u{1F60E}', '\u{1F44D}',
  '\u{1F44E}', '\u{2764}\u{FE0F}', '\u{1F525}', '\u{1F44C}',
  '\u{1F381}', '\u{1F382}', '\u{2B50}', '\u{1F680}',
]

function formatTime(time) {
  if (!time) return ''
  const d = new Date(time)
  const pad = n => String(n).padStart(2, '0')
  return `${pad(d.getHours())}:${pad(d.getMinutes())}`
}

function insertEmoji(emoji) {
  inputText.value += emoji
}

function triggerImageUpload() {
  if (fileInputRef.value) {
    fileInputRef.value.click()
  }
}

async function loadContacts() {
  try {
    const res = await chatApi.getContacts({ page: 1, size: 50 })
    contacts.value = res.records || []
    // 批量获取联系人用户名
    if (contacts.value.length > 0) {
      await fetchUserNames(contacts.value)
    }
  } catch (e) {
    console.warn('加载联系人失败', e)
  }
}

// 批量获取用户名
async function fetchUserNames(userIds) {
  for (const id of userIds) {
    if (!userNames.value[id]) {
      try {
        const res = await fetch(`/api/users/${id}`, {
          headers: { 'Authorization': 'Bearer ' + (localStorage.getItem('token') || '') }
        })
        if (res.ok) {
          const data = await res.json()
          if (data.code === 200 && data.data) {
            userNames.value[id] = data.data.username || data.data.realName || ('用户 #' + id)
          }
        }
      } catch { /* ignore */ }
    }
  }
}

function openChat(contactId) {
  currentContact.value = Number(contactId)
  loadMessages(contactId)
  // 确保有该联系人的用户名
  if (!userNames.value[contactId]) {
    fetchUserNames([contactId])
  }
}

async function loadMessages(contactId) {
  loadingMsgs.value = true
  try {
    const res = await chatApi.getConversation(contactId, { page: 1, size: 50 })
    const list = res.records || []
    // 按时间正序排列：最早的在上面，最新的在下面
    list.sort((a, b) => new Date(a.createdAt || 0) - new Date(b.createdAt || 0))
    messages.value = list
    scrollToBottom()
  } catch (e) {
    console.warn('加载消息失败', e)
  } finally {
    loadingMsgs.value = false
  }
}

// 发送文本消息
function sendText() {
  if (!inputText.value.trim() || !currentContact.value) return
  const text = inputText.value.trim()
  sendMessageViaRest(text, 'TEXT')
  inputText.value = ''
}

// 处理图片选择
function handleImageSelect(event) {
  const file = event.target.files?.[0]
  if (!file || !currentContact.value) return
  
  // 转为 base64 发送
  const reader = new FileReader()
  reader.onload = (e) => {
    sendMessageViaRest(e.target.result, 'IMAGE')
  }
  reader.readAsDataURL(file)
  
  // 清空 input
  if (fileInputRef.value) fileInputRef.value.value = ''
}

// 统一通过 REST API 发送消息（最可靠的方式）
function sendMessageViaRest(content, msgType) {
  // 先添加到本地消息列表（乐观更新）
  const localMsg = {
    uuid: Date.now().toString() + Math.random().toString(36).slice(2, 8),
    senderId: currentUserId,
    receiverId: currentContact.value,
    content: content,
    msgType: msgType,
    createdAt: new Date().toISOString(),
  }
  messages.value.push(localMsg)
  scrollToBottom()

  // 通过 HTTP POST 发送到后端
  sending.value = true
  fetch('/api/chat/send', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + (localStorage.getItem('token') || ''),
    },
    body: JSON.stringify({
      receiverId: currentContact.value,
      content: content,
      msgType: msgType,
    }),
  })
    .then(res => res.json())
    .then(data => {
      if (data.code !== 200) {
        ElMessage.warning(data.message || '发送失败')
        // 移除乐观添加的消息
        const idx = messages.value.findIndex(m => m.uuid === localMsg.uuid)
        if (idx >= 0) messages.value.splice(idx, 1)
      }
    })
    .catch(() => {
      ElMessage.warning('网络异常，消息可能未送达')
    })
    .finally(() => {
      sending.value = false
    })

  // 同时尝试通过 WebSocket 推送（如果已连接）
  try {
    if (stompClient && wsConnected.value) {
      stompClient.publish({
        destination: '/app/chat/send',
        body: JSON.stringify({
          receiverId: currentContact.value,
          content: content,
          msgType: msgType,
        }),
      })
    }
  } catch {}
}

function scrollToBottom() {
  nextTick(() => {
    if (messagesRef.value) {
      messagesRef.value.scrollTop = messagesRef.value.scrollHeight
    }
  })
}

// WebSocket 连接（可选增强）
let stompClient = null

async function connectWebSocket() {
  if (!currentUserId) return

  try {
    const mod = await import('@stomp/stompjs')
    const sockMod = await import('sockjs-client')
    const Client = mod.Client
    const SockJS = sockMod.default

    const socketUrl = window.location.origin + '/ws/chat'
    const socket = new SockJS(socketUrl)

    stompClient = new Client({
      webSocketFactory: () => socket,
      reconnectDelay: 5000,
      heartbeatIncoming: 10000,
      heartbeatOutgoing: 10000,
      onConnect: () => {
        console.log('[WebSocket] 已连接')

        stompClient.subscribe(`/user/${currentUserId}/queue/chat`, (msg) => {
          try {
            const body = JSON.parse(msg.body)
            if (currentContact.value && String(currentContact.value) === String(body.senderId)) {
              const exists = messages.value.some(m => m.uuid === body.uuid)
              if (!exists) {
                messages.value.push(body)
                scrollToBottom()
              }
            }
          } catch (e) {
            console.warn('解析消息失败', e)
          }
        })
      },
      onDisconnect: () => { console.log('[WebSocket] 已断开') },
      onError: (err) => { console.warn('[WebSocket] 错误:', err) },
      onStompError: (frame) => { console.warn('[STOMP] 错误:', frame.headers['message']) },
    })

    stompClient.activate()
  } catch (e) {
    console.warn('[WebSocket] 初始化失败，使用HTTP模式:', e)
  }
}

onMounted(async () => {
  await loadContacts()
  
  // 从路由参数获取联系人ID
  if (route.params.contactId) {
    const cid = Number(route.params.contactId)
    if (cid && !isNaN(cid)) {
      currentContact.value = cid
      await loadMessages(cid)
    }
  }
  
  // 建立 WebSocket 连接
  connectWebSocket()
})

onUnmounted(() => {
  if (stompClient) {
    try { stompClient.deactivate() } catch {}
  }
})
</script>

<style scoped>
.chat-page {
  height: calc(100vh - 120px);
  background: #FAF9F7;
  border-radius: var(--sc-radius-lg);
  overflow: hidden;
}

.chat-container {
  display: flex;
  height: 100%;
  background: var(--sc-white);
  box-shadow: var(--sc-shadow-md);
  border-radius: var(--sc-radius-lg);
  overflow: hidden;
}

/* 左侧联系人列表 */
.chat-sidebar {
  width: 280px;
  min-width: 280px;
  display: flex;
  flex-direction: column;
  border-right: 1px solid rgba(0, 0, 0, 0.06);
  background: var(--sc-white);
}

.sidebar-header {
  padding: 20px 20px 16px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.sidebar-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0;
}

.contacts-list {
  flex: 1;
  overflow-y: auto;
}

.empty-contacts {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: var(--sc-text-muted);
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.empty-contacts p {
  margin: 0 0 6px;
  font-weight: 500;
  color: var(--sc-text-secondary);
}

.empty-contacts span {
  font-size: 13px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 20px;
  cursor: pointer;
  position: relative;
  transition: all var(--sc-transition);
  border-left: 3px solid transparent;
}

.contact-item::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 3px;
  background: var(--sc-primary);
  opacity: 0;
  transition: opacity var(--sc-transition);
}

.contact-item:hover {
  background: var(--sc-bg);
}

.contact-item.active {
  background: var(--sc-primary-bg);
}

.contact-item.active::before {
  opacity: 1;
}

.contact-avatar {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--sc-primary), var(--sc-primary-light));
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.contact-avatar span {
  color: white;
  font-size: 16px;
  font-weight: 600;
}

.contact-content {
  flex: 1;
  min-width: 0;
}

.contact-name {
  font-size: 14px;
  font-weight: 600;
  color: var(--sc-text);
  margin-bottom: 2px;
}

.contact-preview {
  font-size: 12px;
  color: var(--sc-text-muted);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 右侧聊天区 */
.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
  background: #FAF9F7;
}

.chat-placeholder {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: var(--sc-text-muted);
  gap: 10px;
}

.placeholder-icon {
  font-size: 64px;
  margin-bottom: 8px;
}

.chat-placeholder h3 {
  font-size: 18px;
  font-weight: 600;
  color: var(--sc-text-secondary);
  margin: 0;
}

.chat-placeholder p {
  font-size: 14px;
  margin: 0;
}

/* 聊天头部 */
.chat-header {
  padding: 16px 24px;
  background: var(--sc-white);
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  flex-shrink: 0;
}

.header-user-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--sc-teal), #16A085);
  display: flex;
  align-items: center;
  justify-content: center;
}

.header-avatar span {
  color: white;
  font-size: 15px;
  font-weight: 600;
}

.header-username {
  font-size: 17px;
  font-weight: 700;
  color: var(--sc-text);
}

/* 消息区域 */
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.message-wrapper {
  display: flex;
  width: 100%;
}

.message-wrapper.is-self {
  justify-content: flex-end;
}

.message-item {
  display: flex;
  align-items: flex-end;
  gap: 8px;
  max-width: 70%;
}

.message-wrapper.is-self .message-item {
  flex-direction: row-reverse;
}

.message-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--sc-teal), #16A085);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.message-avatar span {
  color: white;
  font-size: 12px;
  font-weight: 600;
}

.self-avatar {
  background: linear-gradient(135deg, var(--sc-primary), var(--sc-primary-light));
}

/* 消息气泡 */
.message-bubble {
  position: relative;
  padding: 10px 14px;
  border-radius: 12px;
  background: var(--sc-white);
  box-shadow: var(--sc-shadow-sm);
  word-break: break-word;
}

.bubble-self {
  background: #4A90E2;
  color: white;
  border-top-right-radius: 4px;
}

.message-bubble:not(.bubble-self) {
  border-top-left-radius: 4px;
}

.msg-text {
  line-height: 1.6;
  white-space: pre-wrap;
  font-size: 14px;
}

.msg-image {
  border-radius: 8px;
  overflow: hidden;
}

.msg-image :deep(.el-image) {
  max-width: 240px;
  max-height: 240px;
  border-radius: 8px;
  display: block;
}

.msg-time {
  font-size: 11px;
  color: var(--sc-text-muted);
  margin-top: 6px;
  text-align: right;
}

.bubble-self .msg-time {
  color: rgba(255, 255, 255, 0.7);
}

.no-msg-hint {
  text-align: center;
  color: var(--sc-text-muted);
  padding: 60px 0;
  font-size: 14px;
}

/* 输入区域 */
.chat-input-area {
  padding: 16px 20px;
  background: var(--sc-white);
  border-top: 1px solid rgba(0, 0, 0, 0.06);
  display: flex;
  gap: 10px;
  align-items: flex-end;
  flex-shrink: 0;
}

.input-toolbar {
  display: flex;
  gap: 6px;
  align-items: flex-end;
  flex-shrink: 0;
}

.toolbar-btn {
  width: 36px;
  height: 36px;
  border: none;
  background: var(--sc-bg);
  border-radius: var(--sc-radius-sm);
  cursor: pointer;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all var(--sc-transition);
}

.toolbar-btn:hover {
  background: var(--sc-bg-warm);
  transform: scale(1.05);
}

.input-box {
  flex: 1;
  position: relative;
}

.input-box textarea {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid rgba(0, 0, 0, 0.08);
  border-radius: var(--sc-radius-md);
  resize: none;
  outline: none;
  font-size: 14px;
  line-height: 1.5;
  font-family: inherit;
  transition: border-color var(--sc-transition);
  max-height: 80px;
  min-height: 38px;
  box-sizing: border-box;
}

.input-box textarea:focus {
  border-color: var(--sc-primary);
  box-shadow: 0 0 0 3px var(--sc-primary-bg);
}

.send-btn {
  width: 42px;
  height: 42px;
  border: none;
  border-radius: 50%;
  background: var(--sc-text-muted);
  color: white;
  cursor: not-allowed;
  font-size: 13px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all var(--sc-transition);
  flex-shrink: 0;
  padding: 0;
}

.send-btn.can-send {
  background: var(--sc-primary);
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(232, 90, 79, 0.35);
}

.send-btn.can-send:hover {
  background: #d94d43;
  transform: scale(1.05);
  box-shadow: 0 6px 16px rgba(232, 90, 79, 0.45);
}

.send-btn.can-send:active {
  transform: scale(0.98);
}

/* 表情选择器 */
.emoji-grid {
  display: grid;
  grid-template-columns: repeat(8, 1fr);
  gap: 4px;
}

.emoji-item {
  font-size: 22px;
  text-align: center;
  cursor: pointer;
  padding: 6px 2px;
  border-radius: var(--sc-radius-sm);
  transition: background var(--sc-transition);
}

.emoji-item:hover {
  background: var(--sc-primary-bg);
}

/* 响应式 */
@media (max-width: 768px) {
  .chat-sidebar {
    width: 220px;
    min-width: 220px;
  }

  .chat-page {
    height: calc(100vh - 56px);
  }

  .message-bubble {
    max-width: 85%;
  }
}
</style>
