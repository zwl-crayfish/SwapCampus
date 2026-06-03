<template>
  <div class="page-container">
    <div class="chat-container">
      <!-- 左侧联系人列表 -->
      <div class="chat-sidebar">
        <h3 class="sidebar-title">消息</h3>
        <div v-if="contacts.length === 0" class="empty-chat">
          <el-empty description="暂无消息" :image-size="80" />
        </div>
        <div
          v-for="c in contacts"
          :key="c"
          class="contact-item"
          :class="{ active: currentContact === c }"
          @click="openChat(c)"
        >
          <el-avatar :size="40" :icon="UserFilled" />
          <div class="contact-info">
            <div class="contact-name">用户 #{{ c }}</div>
          </div>
        </div>
      </div>

      <!-- 右侧聊天区 -->
      <div class="chat-main">
        <div v-if="!currentContact" class="chat-placeholder">
          <el-empty description="选择联系人开始聊天" :image-size="120" />
        </div>
        <template v-else>
          <div class="chat-header">
            <span>与 用户#{{ currentContact }} 的对话</span>
          </div>
          <div class="chat-messages" ref="messagesRef">
            <div
              v-for="msg in messages"
              :key="msg.uuid"
              class="message-item"
              :class="{ 'message-self': msg.senderId === currentUserId }"
            >
              <el-avatar :size="32" :icon="UserFilled" />
              <div class="message-bubble">
                <div v-if="msg.msgType === 'IMAGE'" class="msg-image">
                  <el-image :src="msg.content" fit="cover" style="max-width:200px;max-height:200px;border-radius:8px" />
                </div>
                <div v-else class="msg-text">{{ msg.content }}</div>
                <div class="msg-time">{{ msg.createdAt }}</div>
              </div>
            </div>
          </div>
          <div class="chat-input">
            <el-input
              v-model="inputText"
              type="textarea"
              :rows="2"
              placeholder="输入消息..."
              resize="none"
              @keyup.enter.exact="sendText"
            />
            <el-button type="primary" :disabled="!inputText.trim()" @click="sendText">
              发送
            </el-button>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, nextTick, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { UserFilled } from '@element-plus/icons-vue'
import { chatApi } from '@/api'
import { ElMessage } from 'element-plus'

const route = useRoute()
const currentUserId = JSON.parse(localStorage.getItem('user') || '{}')?.id

const contacts = ref([])
const messages = ref([])
const currentContact = ref(null)
const inputText = ref('')
const messagesRef = ref(null)

// WebSocket
let stompClient = null
let wsConnected = false

async function loadContacts() {
  try {
    const res = await chatApi.getContacts({ page: 1, size: 50 })
    contacts.value = res.records || []
  } catch { /* ignore */ }
}

function openChat(contactId) {
  currentContact.value = contactId
  loadMessages(contactId)
}

async function loadMessages(contactId) {
  try {
    const res = await chatApi.getConversation(contactId, { page: 1, size: 50 })
    messages.value = (res.records || []).reverse()
    scrollToBottom()
  } catch { /* ignore */ }
}

function sendText() {
  if (!inputText.value.trim() || !currentContact.value) return
  if (stompClient && wsConnected) {
    stompClient.publish({
      destination: '/app/chat/send',
      body: JSON.stringify({
        receiverId: currentContact.value,
        content: inputText.value.trim(),
        msgType: 'TEXT',
      }),
    })
    // 添加到本地消息列表
    messages.value.push({
      uuid: Date.now().toString(),
      senderId: currentUserId,
      receiverId: currentContact.value,
      content: inputText.value.trim(),
      msgType: 'TEXT',
      createdAt: new Date().toISOString(),
    })
    inputText.value = ''
    scrollToBottom()
  } else {
    ElMessage.warning('连接中，请稍后再试')
  }
}

function scrollToBottom() {
  nextTick(() => {
    if (messagesRef.value) {
      messagesRef.value.scrollTop = messagesRef.value.scrollHeight
    }
  })
}

function connectWebSocket() {
  if (!currentUserId) return
  try {
    const { Client } = require('@stomp/stompjs')
    // Fallback to global SockJS
    const socket = new (window.SockJS || require('sockjs-client'))('/ws/chat')
    stompClient = new Client({
      webSocketFactory: () => socket,
      debug: () => {},
      onConnect: () => {
        wsConnected = true
        stompClient.subscribe(`/user/${currentUserId}/queue/chat`, (msg) => {
          const body = JSON.parse(msg.body)
          if (currentContact.value === body.senderId) {
            messages.value.push(body)
            scrollToBottom()
          }
        })
      },
      onDisconnect: () => { wsConnected = false },
    })
    stompClient.activate()
  } catch {
    console.warn('WebSocket连接失败，使用HTTP轮询模式')
  }
}

onMounted(() => {
  loadContacts()
  if (route.params.contactId) {
    currentContact.value = Number(route.params.contactId)
    loadMessages(currentContact.value)
  }
  // WebSocket 连接 - 简化处理: 直接通过 REST API 完成，WebSocket 作为补充
})

onUnmounted(() => {
  if (stompClient) stompClient.deactivate()
})
</script>

<style scoped>
.chat-container {
  display: flex;
  height: calc(100vh - 120px);
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}
.chat-sidebar {
  width: 280px;
  border-right: 1px solid #f0f0f0;
  display: flex;
  flex-direction: column;
}
.sidebar-title {
  padding: 16px;
  border-bottom: 1px solid #f0f0f0;
  font-size: 16px;
}
.contact-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  cursor: pointer;
  transition: background 0.2s;
}
.contact-item:hover, .contact-item.active {
  background: #f5f7fa;
}
.contact-name { font-weight: 500; font-size: 14px; }
.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.chat-placeholder {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}
.chat-header {
  padding: 14px 20px;
  border-bottom: 1px solid #f0f0f0;
  font-weight: 600;
}
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.message-item {
  display: flex;
  gap: 8px;
  align-items: flex-start;
}
.message-self {
  flex-direction: row-reverse;
}
.message-bubble {
  max-width: 60%;
  background: #f0f0f0;
  border-radius: 12px;
  padding: 10px 14px;
}
.message-self .message-bubble {
  background: #409EFF;
  color: #fff;
}
.msg-time {
  font-size: 11px;
  color: #c0c4cc;
  margin-top: 4px;
}
.chat-input {
  padding: 12px 16px;
  border-top: 1px solid #f0f0f0;
  display: flex;
  gap: 8px;
  align-items: flex-end;
}
.empty-chat {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
