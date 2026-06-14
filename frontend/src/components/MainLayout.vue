<template>
  <el-container class="layout">
    <!-- 顶部导航 -->
    <el-header class="header">
      <div class="header-inner">
        <router-link to="/" class="logo">
          <el-icon :size="28"><ShoppingBag /></el-icon>
          <span>SwapCampus</span>
        </router-link>
        <div class="header-search">
          <el-input
            v-model="keyword"
            placeholder="搜索闲置物品..."
            size="large"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
            <template #append>
              <el-button @click="handleSearch">
                <el-icon><Search /></el-icon>
              </el-button>
            </template>
          </el-input>
        </div>
        <div class="header-actions">
          <el-button type="primary" @click="$router.push('/publish')">
            <el-icon><Plus /></el-icon>发布闲置
          </el-button>
          <template v-if="userStore.isLoggedIn">
            <el-badge :value="0" :hidden="true">
              <el-button circle @click="$router.push('/chat')">
                <el-icon :size="20"><ChatDotRound /></el-icon>
              </el-button>
            </el-badge>
            <el-dropdown trigger="click">
              <el-avatar :size="36" :src="userStore.user?.avatarUrl" class="avatar" />
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item @click="$router.push('/profile')">
                    <el-icon><User /></el-icon>个人中心
                  </el-dropdown-item>
                  <el-dropdown-item @click="$router.push('/orders')">
                    <el-icon><List /></el-icon>我的订单
                  </el-dropdown-item>
                  <el-dropdown-item @click="$router.push('/my-goods')">
                    <el-icon><Goods /></el-icon>我的发布
                  </el-dropdown-item>
                  <el-dropdown-item v-if="userStore.isAdmin" @click="$router.push('/admin')">
                    <el-icon><Setting /></el-icon>后台管理
                  </el-dropdown-item>
                  <el-dropdown-item divided @click="handleLogout">
                    <el-icon><SwitchButton /></el-icon>退出登录
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
          <template v-else>
            <el-button @click="$router.push('/login')">登录</el-button>
            <el-button type="primary" @click="$router.push('/register')">注册</el-button>
          </template>
        </div>
      </div>
    </el-header>

    <!-- 主体内容 -->
    <el-main class="main-content">
      <router-view />
    </el-main>
  </el-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const keyword = ref('')

function handleSearch() {
  if (keyword.value.trim()) {
    router.push({ path: '/', query: { keyword: keyword.value.trim() } })
  }
}

function handleLogout() {
  userStore.logout()
  ElMessage.success('已退出登录')
  router.push('/')
}
</script>

<style scoped>
/* ========== Layout ========== */
.layout {
  min-height: 100vh;
}

/* ========== Header / Navbar ========== */
.header {
  background: var(--sc-white);
  box-shadow: 0 1px 0 0 var(--sc-border-light), var(--sc-shadow-sm);
  position: sticky;
  top: 0;
  z-index: 100;
  padding: 0;
  height: 64px;
}

.header-inner {
  max-width: 1280px;
  margin: 0 auto;
  height: 100%;
  display: flex;
  align-items: center;
  gap: 28px;
  padding: 0 24px;
}

/* ========== Logo ========== */
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--sc-primary);
  font-size: 20px;
  font-weight: 700;
  letter-spacing: 0.04em;
  white-space: nowrap;
  transition: var(--sc-transition);
}

.logo:hover {
  opacity: 0.82;
}

.logo :deep(.el-icon) {
  color: var(--sc-primary);
}

/* ========== Search Box ========== */
.header-search {
  flex: 1;
  max-width: 480px;
}

.header-search :deep(.el-input__wrapper) {
  border-radius: var(--sc-radius-full) !important;
  box-shadow: 0 0 0 1px var(--sc-border) inset !important;
  padding-left: 16px;
  transition: var(--sc-transition) !important;
}

.header-search :deep(.el-input__wrapper:focus-within) {
  box-shadow: 0 0 0 2px var(--sc-primary-bg), 0 0 0 2px var(--sc-primary) inset !important;
}

.header-search :deep(.el-input__inner)::placeholder {
  color: var(--sc-text-muted);
  font-weight: 400;
}

.header-search :deep(.el-input-group__append) {
  border-radius: 0 var(--sc-radius-full) var(--sc-radius-full) 0 !important;
  background: var(--sc-primary);
  border-color: var(--sc-primary) !important;
  color: var(--sc-white);
  box-shadow: none !important;
  padding: 0 20px;
  transition: var(--sc-transition) !important;
}

.header-search :deep(.el-input-group__append:hover) {
  background: var(--sc-primary-dark);
  border-color: var(--sc-primary-dark) !important;
}

/* ========== Header Actions ========== */
.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* 发布闲置按钮 */
.header-actions :deep(.el-button--primary) {
  position: relative;
  transition: var(--sc-transition) !important;
}

.header-actions :deep(.el-button--primary:hover) {
  transform: translateY(-2px);
  box-shadow: var(--sc-shadow-hover) !important;
}

/* 聊天按钮（圆形图标） */
.header-actions :deep(.el-button.is-circle) {
  border-color: var(--sc-border-light);
  color: var(--sc-text-secondary);
  transition: var(--sc-transition) !important;
}

.header-actions :deep(.el-button.is-circle:hover) {
  color: var(--sc-primary);
  border-color: var(--sc-primary);
  background: var(--sc-primary-bg) !important;
}

/* ========== Avatar Dropdown ========== */
.avatar {
  cursor: pointer;
  border: 2px solid var(--sc-border-light);
  transition: var(--sc-transition);
}

.avatar:hover {
  border-color: var(--sc-primary);
  box-shadow: 0 0 0 4px var(--sc-primary-bg);
}

/* ========== 未登录状态：登录/注册 ========== */
.header-actions :deep(.el-button:not(.el-button--primary):not(.is-circle)) {
  /* 登录按钮 — 文字链接风格 */
  color: var(--sc-text-secondary);
  border: none;
  background: transparent;
  font-weight: 500;
  padding: 8px 12px;
  transition: var(--sc-transition) !important;
}

.header-actions :deep(.el-button:not(.el-button--primary):not(.is-circle):hover) {
  color: var(--sc-primary);
  background: transparent;
}

/* 注册按钮 — 主色描边 */
.header-actions :deep(.el-button--primary.el-button:not(:has(.el-icon))) {
  --el-button-bg-color: transparent !important;
  --el-button-border-color: var(--sc-primary) !important;
  --el-button-text-color: var(--sc-primary) !important;
  --el-button-hover-bg-color: var(--sc-primary) !important;
  --el-button-hover-border-color: var(--sc-primary) !important;
  --el-button-hover-text-color: var(--sc-white) !important;
}

/* ========== Main Content ========== */
.main-content {
  background: var(--sc-bg);
  min-height: calc(100vh - 64px);
  padding: 0;
}
</style>
