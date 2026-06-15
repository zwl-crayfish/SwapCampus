import { createRouter, createWebHistory } from 'vue-router'
import MainLayout from '@/components/MainLayout.vue'
import { getToken, getUser } from '@/composables/useMultiAuth'

const routes = [
  {
    path: '/',
    component: MainLayout,
    children: [
      { path: '', name: 'Home', component: () => import('@/views/Home.vue') },
      { path: 'goods/:uuid', name: 'GoodsDetail', component: () => import('@/views/GoodsDetail.vue') },
      { path: 'publish', name: 'Publish', component: () => import('@/views/Publish.vue'), meta: { auth: true } },
      { path: 'publish/:uuid', name: 'EditGoods', component: () => import('@/views/Publish.vue'), meta: { auth: true } },
      { path: 'chat', name: 'Chat', component: () => import('@/views/Chat.vue'), meta: { auth: true } },
      { path: 'chat/:contactId', name: 'ChatDetail', component: () => import('@/views/Chat.vue'), meta: { auth: true } },
      { path: 'orders', name: 'Orders', component: () => import('@/views/Orders.vue'), meta: { auth: true } },
      { path: 'profile', name: 'Profile', component: () => import('@/views/Profile.vue'), meta: { auth: true } },
      { path: 'profile/:id', name: 'UserProfile', component: () => import('@/views/Profile.vue') },
      { path: 'favorites', name: 'Favorites', component: () => import('@/views/Favorites.vue'), meta: { auth: true } },
      { path: 'my-goods', name: 'MyGoods', component: () => import('@/views/MyGoods.vue'), meta: { auth: true } },
      { path: 'admin', name: 'Admin', component: () => import('@/views/Admin.vue'), meta: { auth: true, admin: true } },
    ],
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})

// 路由守卫 — 使用多账号模块读取 token 和用户信息
router.beforeEach((to, from, next) => {
  const token = getToken()
  const user = getUser()

  if (to.meta.auth && !token) {
    next('/login')
  } else if (to.meta.admin && user?.role !== 1) {
    next('/')
  } else {
    next()
  }
})

export default router
