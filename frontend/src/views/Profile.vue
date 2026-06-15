<template>
  <div class="profile-page">
    <!-- Tab 导航栏 -->
    <nav class="tab-nav">
      <button
        v-for="tab in tabs"
        :key="tab.key"
        class="tab-item"
        :class="{ 'tab-active': activeTab === tab.key }"
        @click="activeTab = tab.key"
      >
        <span class="tab-icon" v-html="tab.icon"></span>
        <span class="tab-label">{{ tab.label }}</span>
        <span v-if="tab.count > 0" class="tab-count">{{ tab.count }}</span>
      </button>
    </nav>

    <!-- ====== Tab 1: 个人信息 ====== -->
    <section v-show="activeTab === 'profile'" class="tab-panel profile-panel">
      <!-- 用户信息卡片 -->
      <div class="profile-card-inner">
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
        <div class="card-header"><h2>编辑资料</h2></div>
        <form class="edit-form" @submit.prevent="handleSave">
          <div class="form-group">
            <label for="phone">手机号</label>
            <input id="phone" type="tel" v-model="editForm.phone" placeholder="请输入手机号" />
          </div>
          <div class="form-group">
            <label for="email">邮箱</label>
            <input id="email" type="email" v-model="editForm.email" placeholder="请输入邮箱" />
          </div>
          <button type="submit" class="save-btn">保存修改</button>
        </form>
      </div>

      <!-- 他人页面提示 -->
      <div v-if="!isSelf && user" class="info-card">
        <div class="other-user-hint">
          <span class="hint-icon">&#128100;</span>
          <p>这是其他用户的个人主页</p>
        </div>
      </div>
    </section>

    <!-- ====== Tab 2: 浏览历史 ====== -->
    <section v-show="activeTab === 'history'" class="tab-panel history-panel">
      <!-- 空状态 -->
      <div v-if="browsingHistory.length === 0 && !historyLoading" class="empty-state">
        <div class="empty-icon-wrapper empty-history-icon">&#128270;</div>
        <p class="empty-text">还没有浏览记录哦，去逛逛吧~</p>
        <router-link to="/" class="empty-action-btn">去发现好物</router-link>
      </div>

      <!-- 历史记录网格 -->
      <div class="history-grid" v-else>
        <div
          v-for="item in pagedHistory"
          :key="item.uuid"
          class="history-item"
          @click="goToDetail(item.uuid)"
        >
          <div class="history-thumb">
            <img v-if="item.coverUrl" :src="item.coverUrl" :alt="item.title" />
            <div v-else class="thumb-placeholder"><span>&#128230;</span></div>
          </div>
          <div class="history-info">
            <h3 class="history-title">{{ item.title }}</h3>
            <div class="history-meta">
              <span class="history-price">&yen;{{ item.price }}</span>
              <span class="history-time">{{ formatRelativeTime(item.viewedAt) }}</span>
            </div>
          </div>
          <button class="delete-history-btn" title="删除此条记录" @click.stop="handleDeleteHistory(item.uuid)">&#10005;</button>
        </div>
      </div>

      <!-- 分页 -->
      <div v-if="browsingHistory.length > historyPageSize" class="pagination-bar">
        <button class="page-btn page-prev" :disabled="historyPage <= 1" @click="historyPage--">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <div class="page-dots">
          <button v-for="p in historyTotalPages" :key="'hp-' + p" class="page-dot" :class="{ active: historyPage === p }" @click="historyPage = p">{{ p }}</button>
        </div>
        <button class="page-btn page-next" :disabled="historyPage >= historyTotalPages" @click="historyPage++">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
        </button>
        <span class="page-info">{{ historyPage }}/{{ historyTotalPages }}</span>
      </div>

      <!-- 清空按钮 -->
      <div v-if="browsingHistory.length > 0" class="panel-actions">
        <button class="clear-all-btn" @click="handleClearAllHistory">&#128465; 清空全部记录</button>
      </div>
    </section>

    <!-- ====== Tab 3: 为你推荐 ====== -->
    <section v-show="activeTab === 'recommend'" class="tab-panel recommend-panel">
      <!-- 加载中 - 骨架屏 -->
      <div v-if="recommendLoading" class="skeleton-grid">
        <div v-for="i in 6" :key="'sk-' + i" class="skeleton-card">
          <div class="skeleton-img"></div>
          <div class="skeleton-line skeleton-line-lg"></div>
          <div class="skeleton-line skeleton-line-sm"></div>
          <div class="skeleton-line skeleton-line-xs"></div>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-else-if="recommendations.length === 0" class="empty-state empty-recommend">
        <div class="empty-icon-wrapper empty-rec-icon">&#129302;</div>
        <p class="empty-text">浏览更多商品后，为你生成专属推荐</p>
        <router-link to="/" class="empty-action-btn rec-action-btn">去逛逛</router-link>
      </div>

      <!-- 推荐卡片网格 -->
      <div class="recommend-grid" v-else>
        <div v-for="item in pagedRecommendations" :key="item.uuid" class="recommend-card" @click="goToDetail(item.uuid)">
          <!-- 匹配度圆环 -->
          <div class="match-ring-wrap">
            <svg class="match-ring" viewBox="0 0 44 44">
              <circle cx="22" cy="22" r="18" fill="none" stroke="rgba(255,255,255,.25)" stroke-width="4" />
              <circle cx="22" cy="22" r="18" fill="none" stroke="url(#ringGrad)" stroke-width="4" stroke-linecap="round"
                :stroke-dasharray="113.1" :stroke-dashoffset="113.1 * (1 - item.matchScore / 100)" transform="rotate(-90 22 22)" />
              <defs>
                <linearGradient id="ringGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stop-color="#a855f7" />
                  <stop offset="100%" stop-color="#3b82f6" />
                </linearGradient>
              </defs>
            </svg>
            <span class="match-text">{{ item.matchScore }}%</span>
          </div>

          <!-- 封面图 -->
          <div class="rec-cover">
            <img v-if="item.coverUrl" :src="item.coverUrl" :alt="item.title" />
            <div v-else class="cover-placeholder"><span>&#128230;</span></div>
            <div class="cover-overlay"></div>
          </div>

          <!-- 信息区 -->
          <div class="rec-info">
            <h3 class="rec-title">{{ item.title }}</h3>
            <div class="rec-bottom">
              <span class="rec-price">&yen;{{ item.price }}</span>
              <span class="rec-condition" :class="'cond-' + (item.condition || 'good')">{{ conditionLabel(item.condition) }}</span>
            </div>
          </div>

          <!-- AI 标签 -->
          <div class="ai-badge"><span>AI 推荐</span></div>
        </div>
      </div>

      <!-- 分页 -->
      <div v-if="recommendations.length > recommendPageSize" class="pagination-bar pagination-bar--purple">
        <button class="page-btn page-prev" :disabled="recommendPage <= 1" @click="recommendPage--">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <div class="page-dots">
          <button v-for="p in recommendTotalPages" :key="'rp-' + p" class="page-dot" :class="{ active: recommendPage === p }" @click="recommendPage = p">{{ p }}</button>
        </div>
        <button class="page-btn page-next" :disabled="recommendPage >= recommendTotalPages" @click="recommendPage++">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
        </button>
        <span class="page-info">{{ recommendPage }}/{{ recommendTotalPages }}</span>
      </div>
    </section>

    <!-- ====== Tab 4: 我的收藏 ====== -->
    <section v-show="activeTab === 'favorites'" class="tab-panel favorites-panel">
      <!-- 加载中 -->
      <div v-if="favLoading" class="skeleton-grid skeleton-grid--fav">
        <div v-for="i in 6" :key="'fv-sk-' + i" class="skeleton-card">
          <div class="skeleton-img"></div>
          <div class="skeleton-line skeleton-line-lg"></div>
          <div class="skeleton-line skeleton-line-sm"></div>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-else-if="favorites.length === 0" class="empty-state">
        <div class="empty-icon-wrapper empty-fav-icon">&#128156;</div>
        <p class="empty-text">还没有收藏喜欢的商品哦</p>
        <router-link to="/" class="empty-action-btn empty-action-btn--rose">去逛逛</router-link>
      </div>

      <!-- 收藏卡片网格 -->
      <div class="favorites-grid" v-else>
        <div v-for="item in pagedFavorites" :key="item.uuid" class="favorite-card" @click="goToDetail(item.uuid)">
          <div class="fav-cover">
            <img v-if="item.coverUrl" :src="item.coverUrl" :alt="item.title" />
            <div v-else class="cover-placeholder"><span>&#128230;</span></div>
            <div class="fav-heart-badge">&#9825;</div>
          </div>
          <div class="fav-info">
            <h3 class="fav-title">{{ item.title }}</h3>
            <div class="fav-bottom">
              <span class="fav-price">&yen;{{ item.price }}</span>
              <button class="unfav-btn" title="取消收藏" @click.stop="handleUnfavorite(item.uuid)">&#10005;</button>
            </div>
          </div>
          <span class="fav-condition-tag" :class="'cond-' + (item.conditionLevel || 'good')">{{ conditionLabel(item.conditionLevel) }}</span>
        </div>
      </div>

      <!-- 分页 -->
      <div v-if="favorites.length > favPageSize" class="pagination-bar pagination-bar--rose">
        <button class="page-btn page-prev" :disabled="favPage <= 1" @click="favPage--">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <div class="page-dots">
          <button v-for="p in favTotalPages" :key="'fp-' + p" class="page-dot" :class="{ active: favPage === p }" @click="favPage = p">{{ p }}</button>
        </div>
        <button class="page-btn page-next" :disabled="favPage >= favTotalPages" @click="favPage++">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
        </button>
        <span class="page-info">{{ favPage }}/{{ favTotalPages }}</span>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { goodsApi, userApi } from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

const route = useRoute()
const router = useRouter()
const user = ref(null)
const isSelf = ref(false)
const editForm = ref({ phone: '', email: '' })

/* ---------- Tab 状态 ---------- */
const activeTab = ref('profile')

/* ---------- 数据状态 ---------- */
const browsingHistory = ref([])
const historyLoading = ref(true)
const historyPage = ref(1)
const historyPageSize = 8

const recommendations = ref([])
const recommendLoading = ref(true)
const recommendPage = ref(1)
const recommendPageSize = 6

const favorites = ref([])
const favLoading = ref(true)
const favPage = ref(1)
const favPageSize = 6

/* ---------- Tab 定义（含动态计数） ---------- */
const tabs = computed(() => [
  {
    key: 'profile',
    label: '个人信息',
    icon: '&#128100;',
    count: 0,
  },
  {
    key: 'history',
    label: '浏览历史',
    icon: '&#9201;',
    count: browsingHistory.value.length,
  },
  {
    key: 'recommend',
    label: '为你推荐',
    icon: '&#10024;',
    count: 0,
  },
  {
    key: 'favorites',
    label: '我的收藏',
    icon: '&#9829;',
    count: favorites.value.length,
  },
])

/* ---------- 分页计算属性 ---------- */
const pagedHistory = computed(() => {
  const start = (historyPage.value - 1) * historyPageSize
  return browsingHistory.value.slice(start, start + historyPageSize)
})
const historyTotalPages = computed(() =>
  Math.max(1, Math.ceil(browsingHistory.value.length / historyPageSize))
)

const pagedRecommendations = computed(() => {
  const start = (recommendPage.value - 1) * recommendPageSize
  return recommendations.value.slice(start, start + recommendPageSize)
})
const recommendTotalPages = computed(() =>
  Math.max(1, Math.ceil(recommendations.value.length / recommendPageSize))
)

const pagedFavorites = computed(() => {
  const start = (favPage.value - 1) * favPageSize
  return favorites.value.slice(start, start + favPageSize)
})
const favTotalPages = computed(() =>
  Math.max(1, Math.ceil(favorites.value.length / favPageSize))
)

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

  if (isSelf.value) {
    loadBrowsingHistory()
    loadRecommendations()
    loadFavorites()
  }
})

/* ---- 浏览历史逻辑 ---- */
function loadBrowsingHistory() {
  historyLoading.value = true
  try {
    const raw = JSON.parse(localStorage.getItem('browsing_history') || '[]')
    browsingHistory.value = raw.slice().sort((a, b) => new Date(b.viewedAt) - new Date(a.viewedAt))
  } catch {
    browsingHistory.value = []
  } finally {
    historyLoading.value = false
  }
}

function handleDeleteHistory(uuid) {
  const list = browsingHistory.value.filter((i) => i.uuid !== uuid)
  browsingHistory.value = list
  localStorage.setItem('browsing_history', JSON.stringify(list))
  if (pagedHistory.value.length === 0 && historyPage.value > 1) historyPage.value--
}

function handleClearAllHistory() {
  ElMessageBox.confirm('确定要清空所有浏览记录吗？', '提示', {
    confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning',
  }).then(() => {
    browsingHistory.value = []
    localStorage.removeItem('browsing_history')
    ElMessage.success('已清空浏览记录')
  }).catch(() => {})
}

/* ---- 推荐流逻辑 ---- */
async function loadRecommendations() {
  recommendLoading.value = true
  try {
    const data = await goodsApi.getRecommendations()
    recommendations.value = Array.isArray(data) ? data : (data?.records || [])
  } catch {
    recommendations.value = []
  } finally {
    recommendLoading.value = false
  }
}

/* ---- 我的收藏逻辑 ---- */
async function loadFavorites() {
  favLoading.value = true
  try {
    const data = await goodsApi.myFavorites({ page: 1, size: 50 })
    favorites.value = Array.isArray(data?.records) ? data.records : []
  } catch {
    favorites.value = []
  } finally {
    favLoading.value = false
  }
}

async function handleUnfavorite(uuid) {
  try {
    await goodsApi.toggleFavorite(uuid)
    favorites.value = favorites.value.filter((f) => f.uuid !== uuid)
    if (pagedFavorites.value.length === 0 && favPage.value > 1) favPage.value--
    ElMessage.success('已取消收藏')
  } catch { /* ignore */ }
}

/* ---- 工具函数 ---- */
function formatRelativeTime(dateStr) {
  if (!dateStr) return ''
  const now = Date.now()
  const target = new Date(dateStr).getTime()
  const diff = now - target

  if (diff < 60000) return '刚刚'
  if (diff < 3600000) return Math.floor(diff / 60000) + '分钟前'
  if (diff < 86400000) return Math.floor(diff / 3600000) + '小时前'
  if (diff < 172800000) {
    const d = new Date(dateStr)
    return `昨天 ${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`
  }
  const days = Math.floor(diff / 86400000)
  if (days < 30) return days + '天前'
  const d = new Date(dateStr)
  return `${d.getMonth()+1}/${d.getDate()}`
}

function conditionLabel(cond) {
  const map = { brandNew: '全新', likeNew: '几乎全新', good: '良好', fair: '一般' }
  return map[cond] || '良好'
}

function goToDetail(uuid) {
  router.push(`/goods/${uuid}`)
}

async function handleSave() {
  try {
    await userApi.updateProfile(editForm.value)
    ElMessage.success('保存成功')
  } catch { /* ignore */ }
}
</script>

<style scoped>
/* ========== 页面整体布局 ========== */
.profile-page {
  max-width: 900px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
}
@media (max-width: 900px) {
  .profile-page { max-width: 640px; }
}

/* ========== Tab 导航栏 ========== */
.tab-nav {
  display: flex;
  gap: 4px;
  padding: 6px;
  background: var(--sc-white);
  border-radius: var(--sc-radius-xl);
  box-shadow: var(--sc-shadow-md);
  position: sticky;
  top: 76px;
  z-index: 50;
}

.tab-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  padding: 11px 16px;
  border: none;
  border-radius: var(--sc-radius-md);
  background: transparent;
  color: var(--sc-text-muted);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all .3s cubic-bezier(.23,1,.32,1);
  position: relative;
  white-space: nowrap;
}
.tab-icon { font-size: 17px; line-height: 1; }
.tab-label { letter-spacing: .02em; }

.tab-count {
  font-size: 11px;
  font-weight: 700;
  padding: 1px 7px;
  border-radius: 999px;
  background: rgba(0,0,0,.06);
  color: var(--sc-text-muted);
  line-height: 1.7;
  min-width: 20px;
  text-align: center;
  transition: all .3s ease;
}

.tab-item:hover:not(.tab-active) {
  background: var(--sc-bg);
  color: var(--sc-text-secondary);
}

/* Tab 激活态 — 四种主题色 */

.tab-item.tab-active {
  color: #fff;
  transform: translateY(-1px);
}

/* Tab 1: 个人信息 - 蓝色 */
.tab-item:nth-child(1).tab-active {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  box-shadow: 0 4px 16px rgba(59,130,246,.30), 0 2px 6px rgba(0,0,0,.04);
}
.tab-item:nth-child(1).tab-active .tab-count {
  background: rgba(255,255,255,.25);
  color: #fff;
}

/* Tab 2: 浏览历史 - 橙色 */
.tab-item:nth-child(2).tab-active {
  background: linear-gradient(135deg, #f59e0b, #ea580c);
  box-shadow: 0 4px 16px rgba(245,158,11,.30), 0 2px 6px rgba(0,0,0,.04);
}
.tab-item:nth-child(2).tab-active .tab-count {
  background: rgba(255,255,255,.25);
  color: #fff;
}

/* Tab 3: 为你推荐 - 紫色 */
.tab-item:nth-child(3).tab-active {
  background: linear-gradient(135deg, #a855f7, #6366f1);
  box-shadow: 0 4px 16px rgba(168,85,247,.30), 0 2px 6px rgba(0,0,0,.04);
}
.tab-item:nth-child(3).tab-active .tab-count {
  background: rgba(255,255,255,.25);
  color: #fff;
}

/* Tab 4: 我的收藏 - 玫红色 */
.tab-item:nth-child(4).tab-active {
  background: linear-gradient(135deg, #ec4899, #f43f5e);
  box-shadow: 0 4px 16px rgba(236,72,153,.30), 0 2px 6px rgba(0,0,0,.04);
}
.tab-item:nth-child(4).tab-active .tab-count {
  background: rgba(255,255,255,.25);
  color: #fff;
}

/* ========== Tab 面板通用 ========== */
.tab-panel {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 28px 24px 24px;
  box-shadow: var(--sc-shadow-md);
  margin-top: 20px;
}

/* ========== 个人信息面板 ========== */
.profile-panel { position: relative; }
.profile-panel::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0;
  height: 3px; border-radius: var(--sc-radius-lg) var(--sc-radius-lg) 0 0;
  background: linear-gradient(135deg, #3b82f6, #2563eb);
}
.profile-panel {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.profile-card-inner {
  background: var(--sc-bg);
  border-radius: var(--sc-radius-md);
  padding: 40px 32px;
  text-align: center;
}
.profile-header { }

.avatar-wrapper { display: flex; justify-content: center; margin-bottom: 18px; }
.user-avatar {
  width: 90px; height: 90px; border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 8px 24px rgba(59,130,246, 0.25); overflow: hidden;
}
.user-avatar span { color: white; font-size: 34px; font-weight: 700; }
.user-avatar img { width: 100%; height: 100%; object-fit: cover; }

.user-name { font-size: 24px; font-weight: 700; color: var(--sc-text); margin: 0 0 6px; }
.user-id { font-size: 13px; color: var(--sc-text-secondary); margin: 0 0 16px; }

.credit-section { max-width: 300px; margin: 0 auto; }
.credit-label { display: block; font-size: 12px; color: var(--sc-text-muted); margin-bottom: 6px; font-weight: 500; }
.credit-bar {
  position: relative; height: 26px;
  background: var(--sc-white); border-radius: var(--sc-radius-full);
  overflow: hidden; display: flex; align-items: center; padding: 3px;
  box-shadow: inset 0 1px 3px rgba(0,0,0,.06);
}
.credit-fill {
  position: absolute; left: 3px; top: 3px; bottom: 3px;
  background: linear-gradient(90deg, var(--sc-teal), #16A085);
  border-radius: var(--sc-radius-full); transition: width .6s ease;
}
.credit-value {
  position: relative; z-index: 1; width: 100%;
  text-align: center; font-size: 13px; font-weight: 600; color: var(--sc-text);
}

.edit-card {
  background: var(--sc-bg); border-radius: var(--sc-radius-md);
  padding: 24px 28px;
}
.card-header { margin-bottom: 20px; }
.card-header h2 { font-size: 17px; font-weight: 700; color: var(--sc-text); margin: 0; }

.edit-form { display: flex; flex-direction: column; gap: 16px; }
.form-group { display: flex; flex-direction: column; gap: 4px; }
.form-group label { font-size: 13px; font-weight: 600; color: var(--sc-text-secondary); }
.form-group input {
  padding: 10px 14px; border: 1px solid rgba(0,0,0,.1);
  border-radius: var(--sc-radius-sm); font-size: 14px; outline: none;
  transition: all var(--sc-transition); font-family: inherit;
  background: var(--sc-white);
}
.form-group input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,.12); }
.form-group input::placeholder { color: var(--sc-text-muted); }

.save-btn {
  padding: 10px 28px; background: linear-gradient(135deg, #3b82f6, #2563eb); color: white;
  border: none; border-radius: var(--sc-radius-sm); font-size: 14px;
  font-weight: 600; cursor: pointer; transition: all var(--sc-transition);
  align-self: flex-start; margin-top: 2px;
}
.save-btn:hover { background: #2563eb; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(59,130,246,.35); }

.info-card {
  background: var(--sc-bg); border-radius: var(--sc-radius-md);
  padding: 28px; text-align: center;
}
.other-user-hint { display: flex; flex-direction: column; align-items: center; gap: 10px; color: var(--sc-text-muted); }
.hint-icon { font-size: 44px; }
.other-user-hint p { margin: 0; font-size: 14px; }

/* ========== 其他面板边框色 ========== */
.history-panel { position: relative; }
.history-panel::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0;
  height: 3px; border-radius: var(--sc-radius-lg) var(--sc-radius-lg) 0 0;
  background: linear-gradient(135deg, #f59e0b, #ea580c);
}
.recommend-panel { position: relative; }
.recommend-panel::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0;
  height: 3px; border-radius: var(--sc-radius-lg) var(--sc-radius-lg) 0 0;
  background: linear-gradient(135deg, #a855f7, #3b82f6);
}
.favorites-panel { position: relative; }
.favorites-panel::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0;
  height: 3px; border-radius: var(--sc-radius-lg) var(--sc-radius-lg) 0 0;
  background: linear-gradient(135deg, #ec4899, #f43f5e);
}

.panel-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

/* ========== 空状态 ========== */
.empty-state {
  display: flex; flex-direction: column; align-items: center;
  padding: 56px 20px 40px; gap: 10px;
}
.empty-icon-wrapper { font-size: 52px; opacity: .45; margin-bottom: 2px; }
.empty-text { font-size: 15px; color: var(--sc-text-muted); margin: 0; }
.empty-action-btn {
  display: inline-block; margin-top: 8px;
  padding: 10px 24px; background: linear-gradient(135deg, #f59e0b, #ea580c);
  color: white; border-radius: var(--sc-radius-sm); font-size: 14px;
  font-weight: 600; text-decoration: none; transition: all .25s ease;
}
.empty-action-btn:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(245,158,11,.35); }
.empty-action-btn--rose { background: linear-gradient(135deg, #ec4899, #f43f5e); }
.empty-action-btn--rose:hover { box-shadow: 0 6px 18px rgba(236,72,153,.35); }
.rec-action-btn { background: linear-gradient(135deg, #a855f7, #3b82f6); }
.rec-action-btn:hover { box-shadow: 0 6px 18px rgba(168,85,247,.35); }

/* ========== 浏览历史模块 ========== */
.clear-all-btn {
  font-size: 13px; color: #ef4444; background: rgba(239,68,68,.08);
  border: none; border-radius: var(--sc-radius-sm); padding: 7px 16px;
  cursor: pointer; font-weight: 600; transition: all .2s ease;
}
.clear-all-btn:hover { background: rgba(239,68,68,.15); color: #dc2626; }

.history-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; overflow: hidden; }
@media (max-width: 520px) { .history-grid { grid-template-columns: 1fr; } }

.history-item {
  display: flex; align-items: center; gap: 12px;
  padding: 10px; border-radius: var(--sc-radius-md);
  background: var(--sc-bg); cursor: pointer;
  transition: all .25s ease; position: relative;
}
.history-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0,0,0,.07);
  background: white;
}

.history-thumb {
  width: 66px; height: 66px; border-radius: var(--sc-radius-sm);
  overflow: hidden; flex-shrink: 0; background: var(--sc-bg-secondary);
}
.history-thumb img { width: 100%; height: 100%; object-fit: cover; }
.thumb-placeholder { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; }

.history-info { flex: 1; min-width: 0; }
.history-title {
  font-size: 13px; font-weight: 600; color: var(--sc-text);
  margin: 0 0 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.history-meta { display: flex; align-items: center; gap: 10px; }
.history-price { font-size: 14px; font-weight: 700; color: #ea580c; }
.history-time { font-size: 11px; color: var(--sc-text-muted); }

.delete-history-btn {
  position: absolute; top: 5px; right: 5px;
  width: 24px; height: 24px; border-radius: 50%;
  border: none; background: transparent; color: var(--sc-text-muted);
  font-size: 13px; cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  opacity: 0; transition: all .2s ease; z-index: 2; line-height: 1;
}
.history-item:hover .delete-history-btn { opacity: 1; }
.delete-history-btn:hover { background: #fef2f2; color: #ef4444; }

/* ========== 我的收藏模块 ========== */
.favorites-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; overflow: hidden; }
@media (max-width: 900px) { .favorites-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 520px) { .favorites-grid { grid-template-columns: 1fr; } }

.favorite-card {
  border-radius: var(--sc-radius-md); overflow: hidden;
  background: var(--sc-bg); cursor: pointer; position: relative;
  transition: all .35s cubic-bezier(.23,1,.32,1);
}
.favorite-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 14px 36px rgba(236,72,153,.16); background: white;
}

.fav-cover {
  position: relative; width: 100%; aspect-ratio: 4/3;
  overflow: hidden; background: var(--sc-bg-secondary);
}
.fav-cover img { width: 100%; height: 100%; object-fit: cover; transition: transform .4s ease; }
.favorite-card:hover .fav-cover img { transform: scale(1.05); }
.cover-placeholder { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 36px; opacity: .25; }

.fav-heart-badge {
  position: absolute; top: 10px; right: 10px; z-index: 2;
  background: rgba(255,255,255,.92); backdrop-filter: blur(6px);
  color: #ec4899; font-size: 17px; line-height: 1;
  width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;
  border-radius: 50%; box-shadow: 0 2px 8px rgba(236,72,153,.15);
}

.fav-info { padding: 10px 12px 12px; }
.fav-title {
  font-size: 13px; font-weight: 600; color: var(--sc-text);
  margin: 0 0 8px; line-height: 1.4;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.fav-bottom { display: flex; align-items: center; justify-content: space-between; }
.fav-price {
  font-size: 16px; font-weight: 800;
  background: linear-gradient(135deg, #ec4899, #f43f5e);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
}
.unfav-btn {
  width: 24px; height: 24px; border-radius: 50%;
  border: none; background: transparent; color: var(--sc-text-muted);
  font-size: 12px; cursor: pointer;
  display: flex; align-items: center; justify-content: center; transition: all .2s ease;
}
.unfav-btn:hover { background: #fef2f2; color: #ef4444; }

.fav-condition-tag {
  position: absolute; bottom: 54px; right: 10px; z-index: 2;
  font-size: 10px; font-weight: 600; padding: 2px 7px;
  border-radius: 999px; white-space: nowrap;
}

/* 骨架屏变体 */
.skeleton-grid--fav .skeleton-img {
  background: linear-gradient(110deg, var(--sc-bg-secondary) 40%, rgba(236,72,153,.06) 50%, var(--sc-bg-secondary) 60%);
  background-size: 200% 100%; animation: shimmer 1.5s infinite;
}
.skeleton-grid--fav .skeleton-line {
  background: linear-gradient(110deg, var(--sc-bg-secondary) 40%, rgba(236,72,153,.04) 50%, var(--sc-bg-secondary) 60%);
  background-size: 200% 100%; animation: shimmer 1.5s infinite; margin-top: 10px;
}

/* ========== 推荐流模块 ========== */
.skeleton-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
@media (max-width: 768px) { .skeleton-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 480px) { .skeleton-grid { grid-template-columns: 1fr; } }

.skeleton-card {
  border-radius: var(--sc-radius-md); overflow: hidden;
  background: var(--sc-bg); padding: 10px;
}
.skeleton-img {
  width: 100%; aspect-ratio: 4/3;
  border-radius: var(--sc-radius-sm);
  background: linear-gradient(110deg, var(--sc-bg-secondary) 40%, rgba(168,85,247,.06) 50%, var(--sc-bg-secondary) 60%);
  background-size: 200% 100%; animation: shimmer 1.5s infinite;
}
.skeleton-line {
  height: 12px; border-radius: 6px;
  background: linear-gradient(110deg, var(--sc-bg-secondary) 40%, rgba(168,85,247,.04) 50%, var(--sc-bg-secondary) 60%);
  background-size: 200% 100%; animation: shimmer 1.5s infinite; margin-top: 10px;
}
.skeleton-line-lg { width: 70%; }
.skeleton-line-sm { width: 45%; }
.skeleton-line-xs { width: 30%; }

@keyframes shimmer { to { background-position-x: -200%; } }

.recommend-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; overflow: hidden; }
@media (max-width: 900px) { .recommend-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 520px) { .recommend-grid { grid-template-columns: 1fr; } }

.recommend-card {
  border-radius: var(--sc-radius-md); overflow: hidden;
  background: var(--sc-bg); cursor: pointer; position: relative;
  transition: all .35s cubic-bezier(.23,1,.32,1);
}
.recommend-card:hover {
  transform: rotate(-2deg) translateY(-5px);
  box-shadow: 0 16px 40px rgba(99,102,241,.18); background: white;
}

.match-ring-wrap { position: absolute; top: 10px; left: 10px; z-index: 3; width: 42px; height: 42px; }
.match-ring { width: 100%; height: 100%; }
.match-text {
  position: absolute; inset: 0; display: flex; align-items: center; justify-content: center;
  font-size: 11px; font-weight: 700; color: white; letter-spacing: -.3px;
  text-shadow: 0 1px 3px rgba(0,0,0,.3);
}

.rec-cover { position: relative; width: 100%; aspect-ratio: 4/3; overflow: hidden; background: var(--sc-bg-secondary); }
.rec-cover img { width: 100%; height: 100%; object-fit: cover; transition: transform .4s ease; }
.recommend-card:hover .rec-cover img { transform: scale(1.06); }
.cover-overlay {
  position: absolute; inset: 0;
  background: linear-gradient(180deg, transparent 55%, rgba(99,102,241,.08) 100%);
  pointer-events: none;
}

.rec-info { padding: 10px 12px 12px; }
.rec-title {
  font-size: 13px; font-weight: 600; color: var(--sc-text);
  margin: 0 0 8px; line-height: 1.4;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.rec-bottom { display: flex; align-items: center; justify-content: space-between; }
.rec-price {
  font-size: 16px; font-weight: 800;
  background: linear-gradient(135deg, #a855f7, #6366f1);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
}
.rec-condition { font-size: 10px; font-weight: 600; padding: 2px 7px; border-radius: 999px; white-space: nowrap; }
.cond-brandNew   { background: #ecfdf5; color: #059669; }
.cond-likeNew    { background: #eff6ff; color: #2563eb; }
.cond-good       { background: #fffbeb; color: #d97706; }
.cond-fair       { background: #fef2f2; color: #dc2626; }

.ai-badge {
  position: absolute; top: 10px; right: 10px; z-index: 3;
  background: linear-gradient(135deg, rgba(168,85,247,.88), rgba(99,102,241,.88));
  backdrop-filter: blur(6px);
  color: white; font-size: 10px; font-weight: 700;
  padding: 3px 7px; border-radius: 999px; letter-spacing: .5px;
}

/* ========== 分页组件 ========== */
.pagination-bar {
  display: flex; align-items: center; justify-content: center;
  gap: 7px; margin-top: 20px; padding-top: 18px;
  border-top: 1px solid var(--sc-border-light);
}

.pagination-bar--purple { --pg-accent: #a855f7; --pg-accent-light: rgba(168,85,247,.12); --pg-active-bg: linear-gradient(135deg, #a855f7, #6366f1); }
.pagination-bar--rose   { --pg-accent: #ec4899; --pg-accent-light: rgba(236,72,153,.12); --pg-active-bg: linear-gradient(135deg, #ec4899, #f43f5e); }
.pagination-bar:not(.pagination-bar--purple):not(.pagination-bar--rose) {
  --pg-accent: #f59e0b; --pg-accent-light: rgba(245,158,11,.12); --pg-active-bg: linear-gradient(135deg, #f59e0b, #ea580c);
}

.page-btn {
  display: inline-flex; align-items: center; justify-content: center;
  width: 32px; height: 32px; border-radius: 9px;
  border: 1.5px solid var(--sc-border); background: var(--sc-white);
  color: var(--sc-text-secondary); cursor: pointer;
  transition: all .25s ease; font-size: 13px;
}
.page-btn:hover:not(:disabled) { border-color: var(--pg-accent); color: var(--pg-accent); background: var(--pg-accent-light); }
.page-btn:disabled { opacity: .3; cursor: not-allowed; background: var(--sc-bg); }

.page-dots { display: flex; align-items: center; gap: 4px; }

.page-dot {
  min-width: 32px; height: 32px; border-radius: 9px;
  border: 1.5px solid transparent; background: transparent;
  color: var(--sc-text-muted); font-size: 13px; font-weight: 600;
  cursor: pointer; transition: all .25s ease;
  display: flex; align-items: center; justify-content: center; padding: 0 4px;
}
.page-dot:hover { background: var(--pg-accent-light); color: var(--pg-accent); }
.page-dot.active {
  background: var(--pg-active-bg); color: #fff; border-color: transparent;
  box-shadow: 0 4px 14px rgba(168,85,247,.28); font-weight: 700;
}
.pagination-bar:not(.pagination-bar--purple):not(.pagination-bar--rose) .page-dot.active {
  box-shadow: 0 4px 14px rgba(245,158,11,.28);
}

.page-info { font-size: 12px; color: var(--sc-text-muted); font-weight: 500; margin-left: 3px; letter-spacing: .02em; }
</style>
