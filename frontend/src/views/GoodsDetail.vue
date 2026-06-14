<template>
  <div class="goods-detail-page" v-loading="loading">
    <div v-if="goods" class="detail-grid">
      <!-- 左侧图片区 -->
      <div class="detail-images">
        <div class="main-image-box">
          <el-image
            v-if="images.length > 0"
            :src="images[currentImageIndex]?.url"
            fit="contain"
            class="main-image"
          />
          <div v-else class="no-image-placeholder">
            <el-icon :size="80"><PictureFilled /></el-icon>
            <p>暂无图片</p>
          </div>
        </div>
        <div class="image-thumbs" v-if="images.length > 1">
          <div
            v-for="(img, i) in images"
            :key="i"
            class="thumb-item"
            :class="{ active: i === currentImageIndex }"
            @click="currentImageIndex = i"
          >
            <el-image :src="img.url" fit="cover" class="thumb-img" />
          </div>
        </div>
      </div>

      <!-- 右侧信息区 -->
      <div class="detail-info">
        <h1 class="info-title">{{ goods.title }}</h1>
        <div class="info-price">¥{{ goods.price }}</div>

        <div class="info-table-card">
          <el-descriptions :column="2" size="large" :labelStyle="{ color: 'var(--sc-text-secondary)', minWidth: '80px' }">
            <el-descriptions-item label="成色" :span="2">
              <div class="condition-row">
                <el-rate v-model="conditionStars" disabled show-score text-color="#F39C12" />
                <span class="condition-text">（{{ goods.conditionLevel }}/10 新品）</span>
              </div>
            </el-descriptions-item>
            <el-descriptions-item label="交易方式">
              <el-tag :type="goods.tradeMethod === 'FACE' ? 'success' : 'warning'">
                {{ goods.tradeMethod === 'FACE' ? '面交' : goods.tradeMethod === 'LOCKER' ? '邮件柜' : '均可' }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="校区">{{ goods.campusLocation || '未指定' }}</el-descriptions-item>
            <el-descriptions-item label="发布时间">{{ formatTime(goods.createdAt) }}</el-descriptions-item>
            <el-descriptions-item label="浏览量">
              <el-icon><View /></el-icon> {{ goods.viewCount }}
            </el-descriptions-item>
            <el-descriptions-item label="收藏数">
              <el-icon><Star /></el-icon> {{ goods.favoriteCount }}
            </el-descriptions-item>
          </el-descriptions>
        </div>

        <div class="action-buttons">
          <el-button
            :type="isFavorited ? 'warning' : ''"
            size="large"
            class="action-btn action-btn--outline"
            @click="handleFavorite"
            v-if="userStore.isLoggedIn"
          >
            <el-icon><Star /></el-icon>{{ isFavorited ? '已收藏' : '收藏' }}
          </el-button>
          <el-button type="primary" size="large" class="action-btn action-btn--primary" @click="handleContact" v-if="userStore.isLoggedIn">
            <el-icon><ChatDotRound /></el-icon>联系卖家
          </el-button>
          <el-button type="success" size="large" class="action-btn action-btn--success" @click="showOrderDialog = true" v-if="userStore.isLoggedIn">
            <el-icon><ShoppingCart /></el-icon>立即购买
          </el-button>
        </div>

        <!-- 卖家信息卡 -->
        <div class="seller-card">
          <div class="seller-info">
            <el-avatar :size="56" class="seller-avatar">
              <span style="font-size:20px;font-weight:bold">{{ sellerName.charAt(0).toUpperCase() }}</span>
            </el-avatar>
            <div class="seller-detail">
              <div class="seller-name">卖家：{{ sellerName }}</div>
              <div class="seller-credit">信用分：<span class="credit-value">{{ sellerCredit }}</span></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 商品描述区域 -->
    <div v-if="goods" class="desc-section">
      <h2 class="desc-title">商品详情</h2>
      <div class="desc-content">{{ goods.description || '卖家很懒，没有留下描述~' }}</div>
    </div>

    <!-- 商品不存在 -->
    <div v-if="!loading && !goods" class="not-found-state">
      <el-icon :size="72"><WarningFilled /></el-icon>
      <h2>商品不存在</h2>
      <p>该商品可能已被下架或删除</p>
      <el-button type="primary" size="large" @click="$router.push('/')">返回首页</el-button>
    </div>

    <!-- 下单对话框 -->
    <el-dialog v-model="showOrderDialog" title="确认下单" width="480px" class="order-dialog" :rounded="true">
      <el-form label-width="100px" class="order-form">
        <el-form-item label="交易方式">
          <el-radio-group v-model="orderTradeMethod">
            <el-radio value="FACE">面交</el-radio>
            <el-radio value="LOCKER">邮件柜</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="面交地点" v-if="orderTradeMethod === 'FACE'">
          <el-input v-model="orderLocation" placeholder="如：图书馆门口" />
        </el-form-item>
        <el-form-item label="面交时间" v-if="orderTradeMethod === 'FACE'">
          <el-date-picker v-model="orderTime" type="datetime" placeholder="选择时间" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showOrderDialog = false" size="large">取消</el-button>
          <el-button type="primary" @click="handleCreateOrder" :loading="ordering" size="large">确认下单</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { goodsApi, orderApi } from '@/api'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const goods = ref(null)
const images = ref([])
const isFavorited = ref(false)
const loading = ref(true)
const currentImageIndex = ref(0)

const sellerName = ref('加载中...')
const sellerCredit = ref('-')

const showOrderDialog = ref(false)
const orderTradeMethod = ref('FACE')
const orderLocation = ref('')
const orderTime = ref(null)
const ordering = ref(false)

const conditionStars = computed(() => {
  if (!goods.value) return 0
  return Math.min(5, Math.ceil(goods.value.conditionLevel / 2))
})

function formatTime(val) {
  if (!val) return '未知'
  const s = String(val)
  // 处理 LocalDateTime 格式 "2024-01-15T10:30:00" 或 "2024-01-15 10:30:00"
  return s.substring(0, 16).replace('T', ' ')
}

async function load() {
  loading.value = true
  try {
    const res = await goodsApi.detail(route.params.uuid)
    goods.value = res.goods
    images.value = res.images || []
    isFavorited.value = res.isFavorited || false

    // 获取卖家信息
    if (goods.value && goods.value.sellerId) {
      fetchSellerInfo(goods.value.sellerId)
    }
  } catch (e) {
    goods.value = null
    ElMessage.error('商品加载失败，可能已被删除或下架')
  } finally {
    loading.value = false
  }
}

async function fetchSellerInfo(userId) {
  try {
    const res = await fetch(`/api/users/${userId}`, {
      headers: { 'Authorization': 'Bearer ' + (localStorage.getItem('token') || '') }
    })
    if (res.ok) {
      const data = await res.json()
      if (data.code === 200 && data.data) {
        sellerName.value = data.data.username || data.data.realName || ('用户 #' + userId)
        sellerCredit.value = data.data.creditScore || '-'
      } else {
        sellerName.value = '用户 #' + userId
        sellerCredit.value = '-'
      }
    } else {
      sellerName.value = '用户 #' + userId
      sellerCredit.value = '-'
    }
  } catch {
    sellerName.value = '用户 #' + userId
    sellerCredit.value = '-'
  }
}

async function handleFavorite() {
  await goodsApi.toggleFavorite(goods.value.uuid)
  isFavorited.value = !isFavorited.value
  ElMessage.success(isFavorited.value ? '已收藏' : '已取消收藏')
}

function handleContact() {
  router.push(`/chat/${goods.value.sellerId}`)
}

async function handleCreateOrder() {
  ordering.value = true
  try {
    await orderApi.create({
      goodsUuid: goods.value.uuid,
      tradeMethod: orderTradeMethod.value,
      meetLocation: orderLocation.value,
      meetTime: orderTime.value?.toISOString(),
    })
    ElMessage.success('下单成功')
    showOrderDialog.value = false
    router.push('/orders')
  } finally {
    ordering.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.goods-detail-page {
  max-width: 1100px;
  margin: 0 auto;
  padding: 24px;
}

/* 双栏布局 */
.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 36px;
  margin-bottom: 32px;
}

@media (max-width: 860px) {
  .detail-grid {
    grid-template-columns: 1fr;
  }
}

/* ===== 左侧图片区 ===== */
.detail-images {
  display: flex;
  flex-direction: column;
}

.main-image-box {
  width: 100%;
  height: 420px;
  background: #f0f0f0;
  border-radius: var(--sc-radius-lg);
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.main-image {
  width: 100%;
  height: 100%;
}

.no-image-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
  gap: 12px;
}

.image-thumbs {
  display: flex;
  gap: 10px;
  margin-top: 14px;
  overflow-x: auto;
  padding-bottom: 4px;
}

.thumb-item {
  cursor: pointer;
  border: 2.5px solid transparent;
  border-radius: 10px;
  overflow: hidden;
  transition: border-color 0.2s, transform 0.2s;
  flex-shrink: 0;
}

.thumb-item:hover {
  transform: translateY(-2px);
}

.thumb-item.active {
  border-color: var(--sc-primary);
}

.thumb-img {
  width: 68px;
  height: 68px;
  border-radius: 8px;
  display: block;
}

/* ===== 右侧信息区 ===== */
.detail-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.info-title {
  font-size: 28px;
  font-weight: 700;
  color: var(--sc-text);
  line-height: 1.35;
  margin: 0;
}

.info-price {
  font-size: 36px;
  color: var(--sc-primary);
  font-weight: 800;
  letter-spacing: -0.5px;
}

/* 信息表格卡片 */
.info-table-card {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 20px 24px;
  box-shadow: var(--sc-shadow-md);
}

/* 成色行 - 独占一行，充足间距 */
.condition-row {
  display: flex;
  align-items: center;
  gap: 12px;
}
.condition-text {
  font-size: 14px;
  color: var(--sc-text-secondary);
  font-weight: 500;
}

/* 操作按钮组 */
.action-buttons {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
}

.action-btn {
  font-size: 15px;
  font-weight: 600;
  padding: 12px 28px;
  border-radius: 12px !important;
  transition: all 0.25s ease;
}

.action-btn--outline {
  border: 2px solid var(--sc-primary) !important;
  color: var(--sc-primary) !important;
  background: transparent !important;
}

.action-btn--outline:hover {
  background: rgba(232, 90, 79, 0.06) !important;
  transform: translateY(-1px);
}

.action-btn--primary {
  background: var(--sc-primary) !important;
  border-color: var(--sc-primary) !important;
  font-size: 16px;
  padding: 13px 32px;
}

.action-btn--primary:hover {
  background: var(--sc-primary-dark) !important;
  transform: translateY(-1px);
}

.action-btn--success {
  background: var(--sc-teal) !important;
  border-color: var(--sc-teal) !important;
  font-size: 16px;
  padding: 13px 32px;
}

.action-btn--success:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

/* 卖家信息卡 */
.seller-card {
  background: #FFF9F5;
  border-radius: var(--sc-radius-lg);
  padding: 20px 24px;
  border: 1px solid rgba(243, 156, 18, 0.12);
}

.seller-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.seller-avatar {
  flex-shrink: 0;
  background: linear-gradient(135deg, var(--sc-primary), var(--sc-accent));
  color: white;
}

.seller-detail {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.seller-name {
  font-weight: 700;
  font-size: 16px;
  color: var(--sc-text);
}

.seller-credit {
  font-size: 14px;
  color: var(--sc-text-secondary);
}

.credit-value {
  color: var(--sc-teal);
  font-weight: 700;
  font-size: 15px;
}

/* ===== 商品描述区域 ===== */
.desc-section {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 28px 32px;
  box-shadow: var(--sc-shadow-md);
  margin-bottom: 40px;
}

.desc-title {
  font-size: 20px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0 0 16px 0;
  padding-bottom: 12px;
  border-bottom: 2px solid var(--sc-bg);
}

.desc-content {
  white-space: pre-wrap;
  line-height: 1.85;
  min-height: 80px;
  color: var(--sc-text);
  font-size: 15px;
}

/* ===== 下单对话框 ===== */
.order-dialog :deep(.el-dialog) {
  border-radius: 28px !important;
  overflow: hidden;
}

.order-form {
  padding: 10px 0;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* ===== 商品不存在状态 ===== */
.not-found-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
  color: var(--sc-text-secondary);
  gap: 16px;
}

.not-found-state h2 {
  font-size: 22px;
  color: var(--sc-text);
  margin: 0;
}

.not-found-state p {
  font-size: 15px;
  color: var(--sc-text-muted);
  margin: 0;
}
</style>
