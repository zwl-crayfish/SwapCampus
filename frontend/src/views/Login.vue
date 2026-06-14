<template>
  <div class="auth-page">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
      <div class="float-emoji emoji-1">🎓</div>
      <div class="float-emoji emoji-2">📚</div>
      <div class="float-emoji emoji-3">✨</div>
    </div>

    <!-- 主卡片 -->
    <div class="auth-card">
      <!-- Logo 区域 -->
      <div class="logo-section">
        <div class="logo-icon">
          <el-icon :size="40"><ShoppingBag /></el-icon>
        </div>
        <h1 class="brand-name">SwapCampus</h1>
        <p class="brand-slogan">校园闲置交易平台</p>
      </div>

      <!-- 表单区域 -->
      <el-form ref="formRef" :model="form" :rules="rules" label-width="0" size="large" class="auth-form">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" prefix-icon="User" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" prefix-icon="Lock" show-password />
        </el-form-item>
        <el-form-item>
          <button type="button" class="submit-btn" :class="{ 'is-loading': loading }" :disabled="loading" @click="handleLogin">
            <span v-if="!loading">登 录</span>
            <span v-else class="loading-text">登录中...</span>
          </button>
        </el-form-item>
      </el-form>

      <!-- 底部链接 -->
      <div class="auth-link">
        还没有账号？<router-link to="/register" class="link-highlight">去注册 →</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const loading = ref(false)

const form = ref({ username: '', password: '' })
const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, min: 6, message: '密码至少6位', trigger: 'blur' }],
}

async function handleLogin() {
  loading.value = true
  try {
    await userStore.login(form.value.username, form.value.password)
    ElMessage.success('登录成功')
    router.push('/')
  } catch {
    // 错误已在拦截器处理
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap');

/* ========== 页面容器 ========== */
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #FFF9F5 0%, #FFE8E4 50%, #FFD9D4 100%);
  position: relative;
  overflow: hidden;
  font-family: 'DM Sans', -apple-system, BlinkMacSystemFont, sans-serif;
}

/* ========== 背景装饰 ========== */
.bg-decoration {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: hidden;
}

.circle {
  position: absolute;
  border-radius: 50%;
  opacity: 0.15;
}

.circle-1 {
  width: 400px;
  height: 400px;
  background: #E85A4F;
  top: -120px;
  left: -100px;
  animation: floatSlow 8s ease-in-out infinite;
}

.circle-2 {
  width: 300px;
  height: 300px;
  background: #F39C12;
  bottom: -80px;
  right: -60px;
  animation: floatSlow 10s ease-in-out infinite reverse;
}

.circle-3 {
  width: 180px;
  height: 180px;
  background: #1ABC9C;
  top: 40%;
  right: 10%;
  animation: floatSlow 7s ease-in-out infinite 1s;
}

.float-emoji {
  position: absolute;
  font-size: 32px;
  opacity: 0.25;
  animation: emojiFloat 6s ease-in-out infinite;
}

.emoji-1 {
  top: 15%;
  right: 15%;
  font-size: 40px;
  animation-delay: 0s;
}

.emoji-2 {
  bottom: 25%;
  left: 12%;
  font-size: 36px;
  animation-delay: 2s;
}

.emoji-3 {
  top: 60%;
  right: 8%;
  font-size: 28px;
  animation-delay: 4s;
}

@keyframes floatSlow {
  0%, 100% { transform: translateY(0) scale(1); }
  50% { transform: translateY(-20px) scale(1.03); }
}

@keyframes emojiFloat {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  33% { transform: translateY(-12px) rotate(5deg); }
  66% { transform: translateY(8px) rotate(-3deg); }
}

/* ========== 主卡片 ========== */
.auth-card {
  background: #fff;
  border-radius: 28px;
  padding: 48px 44px 40px;
  width: 420px;
  max-width: 90vw;
  box-shadow:
    0 20px 60px rgba(232, 90, 79, 0.10),
    0 8px 24px rgba(0, 0, 0, 0.06);
  position: relative;
  z-index: 10;
  animation: fadeInUp 0.7s cubic-bezier(0.22, 1, 0.36, 1) both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(36px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* ========== Logo 区域 ========== */
.logo-section {
  text-align: center;
  margin-bottom: 36px;
}

.logo-icon {
  width: 72px;
  height: 72px;
  background: linear-gradient(135deg, #E85A4F 0%, #F07066 100%);
  border-radius: 20px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  margin-bottom: 16px;
  box-shadow: 0 8px 24px rgba(232, 90, 79, 0.30);
}

.brand-name {
  font-size: 28px;
  font-weight: 700;
  color: #E85A4F;
  margin: 0 0 6px;
  letter-spacing: -0.5px;
}

.brand-slogan {
  font-size: 14px;
  color: #95a5a6;
  margin: 0;
  font-weight: 500;
  letter-spacing: 1px;
}

/* ========== 表单区域 ========== */
.auth-form {
  margin-bottom: 8px;
}

.auth-form :deep(.el-input__wrapper) {
  border-radius: 12px;
  padding: 4px 16px;
  box-shadow: 0 0 0 1px #e8e8e8 inset;
  transition: all 0.3s ease;
  background: #fafafa;
}

.auth-form :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #d0d0d0 inset;
}

.auth-form :deep(.el-input__wrapper.is-focus) {
  box-shadow:
    0 0 0 1px #E85A4F inset,
    0 0 0 4px rgba(232, 90, 79, 0.10),
    0 0 20px rgba(232, 90, 79, 0.08);
  background: #fff;
}

.auth-form :deep(.el-input__inner) {
  font-size: 15px;
  font-family: 'DM Sans', sans-serif;
}

.auth-form :deep(.el-input__prefix .el-icon) {
  color: #b0b0b0;
  font-size: 17px;
}

.auth-form :deep(.el-form-item) {
  margin-bottom: 22px;
}

/* ========== 提交按钮 ========== */
.submit-btn {
  width: 100%;
  height: 48px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(135deg, #E85A4F 0%, #f06e64 100%);
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  font-family: 'DM Sans', sans-serif;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.22, 1, 0.36, 1);
  position: relative;
  overflow: hidden;
  letter-spacing: 2px;
  box-shadow: 0 6px 20px rgba(232, 90, 79, 0.30);
}

.submit-btn::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #d94d42 0%, #E85A4F 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(232, 90, 79, 0.35);
}

.submit-btn:hover:not(:disabled)::before {
  opacity: 1;
}

.submit-btn:active:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 18px rgba(232, 90, 79, 0.30);
}

.submit-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.submit-btn span {
  position: relative;
  z-index: 1;
}

.loading-text {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.loading-text::before {
  content: '';
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
  display: inline-block;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ========== 底部链接 ========== */
.auth-link {
  text-align: center;
  color: #95a5a6;
  font-size: 14px;
  font-weight: 500;
  margin-top: 4px;
}

.link-highlight {
  color: #E85A4F;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.25s ease;
  position: relative;
}

.link-highlight::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background: #E85A4F;
  border-radius: 1px;
  transition: width 0.3s ease;
}

.link-highlight:hover::after {
  width: 100%;
}
</style>
