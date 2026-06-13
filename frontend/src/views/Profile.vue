<template>
  <div class="profile-page">
    <!-- 用户信息卡片 -->
    <div class="profile-card">
      <div class="profile-header">
        <div class="avatar-wrapper">
          <div class="user-avatar">
            <span v-if="!user?.avatarUrl">{{ (user?.realName || user?.username || '?').charAt(0).toUpperCase() }}</span>
            <img v-else :src="user.avatarUrl" :alt="user.realName" />
          </div>
        </div>
        <h1 class="user-name">{{ user?.realName || user?.username || '用户' }}</h1>
        <p class="user-id">学号: {{ user?.studentId || '未设置' }}</p>
        <div class="credit-section">
          <span class="credit-label">信用分</span>
          <div class="credit-bar">
            <div class="credit-fill" :style="{ width: Math.min((user?.creditScore || 80) / 100 * 100, 100) + '%' }"></div>
            <span class="credit-value">{{ user?.creditScore || 80 }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 编辑区域（仅自己的页面） -->
    <div v-if="isSelf" class="edit-card">
      <div class="card-header">
        <h2>编辑资料</h2>
      </div>
      <form class="edit-form" @submit.prevent="handleSave">
        <div class="form-group">
          <label for="phone">手机号</label>
          <input
            id="phone"
            type="tel"
            v-model="editForm.phone"
            placeholder="请输入手机号"
          />
        </div>
        <div class="form-group">
          <label for="email">邮箱</label>
          <input
            id="email"
            type="email"
            v-model="editForm.email"
            placeholder="请输入邮箱"
          />
        </div>
        <button type="submit" class="save-btn">保存修改</button>
      </form>
    </div>

    <!-- 他人页面提示 -->
    <div v-if="!isSelf && user" class="info-card">
      <div class="other-user-hint">
        <span class="hint-icon">👤</span>
        <p>这是其他用户的个人主页</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { UserFilled } from '@element-plus/icons-vue'
import { userApi } from '@/api'
import { ElMessage } from 'element-plus'

const route = useRoute()
const user = ref(null)
const isSelf = ref(false)
const editForm = ref({ phone: '', email: '' })

onMounted(async () => {
  const currentUser = JSON.parse(localStorage.getItem('user') || '{}')
  const userId = route.params.id || currentUser.id
  isSelf.value = !route.params.id || Number(route.params.id) === currentUser.id

  try {
    const api = isSelf.value ? userApi.getMe : userApi.getProfile
    user.value = await api(userId)
    if (isSelf.value) {
      editForm.value = { phone: user.value.phone || '', email: user.value.email || '' }
    }
  } catch { /* ignore */ }
})

async function handleSave() {
  try {
    await userApi.updateProfile(editForm.value)
    ElMessage.success('保存成功')
  } catch { /* ignore */ }
}
</script>

<style scoped>
.profile-page {
  max-width: 600px;
  margin: 0 auto;
}

/* 用户信息卡片 */
.profile-card {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 40px 32px;
  box-shadow: var(--sc-shadow-md);
  margin-bottom: 24px;
}

.profile-header {
  text-align: center;
}

.avatar-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.user-avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--sc-primary), var(--sc-primary-light));
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 24px rgba(232, 90, 79, 0.25);
  overflow: hidden;
}

.user-avatar span {
  color: white;
  font-size: 36px;
  font-weight: 700;
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-name {
  font-size: 26px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0 0 8px;
}

.user-id {
  font-size: 14px;
  color: var(--sc-text-secondary);
  margin: 0 0 20px;
}

.credit-section {
  max-width: 280px;
  margin: 0 auto;
}

.credit-label {
  display: block;
  font-size: 13px;
  color: var(--sc-text-muted);
  margin-bottom: 8px;
  font-weight: 500;
}

.credit-bar {
  position: relative;
  height: 28px;
  background: var(--sc-bg);
  border-radius: var(--sc-radius-full);
  overflow: hidden;
  display: flex;
  align-items: center;
  padding: 3px;
}

.credit-fill {
  position: absolute;
  left: 3px;
  top: 3px;
  bottom: 3px;
  background: linear-gradient(90deg, var(--sc-teal), #16A085);
  border-radius: var(--sc-radius-full);
  transition: width 0.6s ease;
}

.credit-value {
  position: relative;
  z-index: 1;
  width: 100%;
  text-align: center;
  font-size: 14px;
  font-weight: 600;
  color: var(--sc-text);
}

/* 编辑卡片 */
.edit-card {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 28px 32px;
  box-shadow: var(--sc-shadow-md);
}

.card-header {
  margin-bottom: 24px;
}

.card-header h2 {
  font-size: 18px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0;
}

.edit-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-group label {
  font-size: 14px;
  font-weight: 600;
  color: var(--sc-text-secondary);
}

.form-group input {
  padding: 12px 16px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  border-radius: var(--sc-radius-sm);
  font-size: 14px;
  outline: none;
  transition: all var(--sc-transition);
  font-family: inherit;
}

.form-group input:focus {
  border-color: var(--sc-primary);
  box-shadow: 0 0 0 3px var(--sc-primary-bg);
}

.form-group input::placeholder {
  color: var(--sc-text-muted);
}

.save-btn {
  padding: 12px 32px;
  background: var(--sc-primary);
  color: white;
  border: none;
  border-radius: var(--sc-radius-sm);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all var(--sc-transition);
  align-self: flex-start;
  margin-top: 4px;
}

.save-btn:hover {
  background: #d94d43;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(232, 90, 79, 0.35);
}

.save-btn:active {
  transform: translateY(0);
}

/* 他人页面提示 */
.info-card {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 32px;
  box-shadow: var(--sc-shadow-md);
  text-align: center;
}

.other-user-hint {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  color: var(--sc-text-muted);
}

.hint-icon {
  font-size: 48px;
}

.other-user-hint p {
  margin: 0;
  font-size: 15px;
}
</style>
