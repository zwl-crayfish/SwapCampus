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
.layout {
  min-height: 100vh;
}
.header {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  position: sticky;
  top: 0;
  z-index: 100;
  padding: 0;
  height: 64px;
}
.header-inner {
  max-width: 1200px;
  margin: 0 auto;
  height: 100%;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 0 20px;
}
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #409EFF;
  font-size: 20px;
  font-weight: bold;
  white-space: nowrap;
}
.header-search {
  flex: 1;
  max-width: 480px;
}
.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}
.avatar {
  cursor: pointer;
  border: 2px solid #e8e8e8;
}
.main-content {
  background: #f5f7fa;
  min-height: calc(100vh - 64px);
  padding: 0;
}
</style>
