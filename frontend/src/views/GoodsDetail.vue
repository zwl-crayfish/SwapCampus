<template>
  <div class="goods-detail-page" v-loading="loading">
    <div v-if="goods" class="detail-grid">
      <!-- 左侧图片区 -->
      <div class="detail-images">
        <div class="main-image-box">
          <el-image
            v-if="images.length > 0"
            :src="images[currentImageIndex]?.url"
            fit="cover"
            class="main-image"
          />
          <div v-else class="no-image-placeholder">
            <img src="/placeholder.png" alt="暂无图片" />
          </div>
          <!-- 左右切换箭头 -->
          <template v-if="images.length > 1">
            <button class="img-arrow img-arrow--left" @click="prevImage" @mouseenter="showArrow = 'left'" @mouseleave="showArrow = null">
              <el-icon><ArrowLeft /></el-icon>
            </button>
            <button class="img-arrow img-arrow--right" @click="nextImage" @mouseenter="showArrow = 'right'" @mouseleave="showArrow = null">
              <el-icon><ArrowRight /></el-icon>
            </button>
          </template>
          <!-- 图片计数 -->
          <div class="image-counter" v-if="images.length > 1">{{ currentImageIndex + 1 }} / {{ images.length }}</div>
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
            type="danger"
            class="action-btn action-btn--report"
            plain
            @click="showReportDialog = true"
            v-if="userStore.isLoggedIn"
          >
            <el-icon><Warning /></el-icon>举报商品
          </el-button>
          <el-button
            :type="isFavorited ? 'warning' : ''"
            class="action-btn action-btn--secondary"
            @click="handleFavorite"
            v-if="userStore.isLoggedIn"
          >
            <el-icon><Star /></el-icon>{{ isFavorited ? '已收藏' : '收藏' }}
          </el-button>
          <el-button type="primary" class="action-btn action-btn--contact" @click="handleContact" v-if="userStore.isLoggedIn">
            <el-icon><ChatDotRound /></el-icon>联系卖家
          </el-button>
          <el-button
            type="success"
            class="action-btn action-btn--buy"
            :disabled="goods?.status !== 1"
            @click="showOrderDialog = true"
            v-if="userStore.isLoggedIn"
          >
            <el-icon><ShoppingCart /></el-icon>{{ goods?.status === 1 ? '立即购买' : buyStatusText }}
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

    <!-- 举报对话框 -->
    <el-dialog v-model="showReportDialog" title="举报商品" width="480px" class="report-dialog" :rounded="true">
      <p class="report-tip">请选择举报原因并填写详细描述，我们将尽快审核处理。</p>
      <el-form label-width="90px" class="report-form">
        <el-form-item label="举报原因" required>
          <el-select v-model="reportForm.reason" placeholder="请选择举报原因" style="width:100%">
            <el-option label="虚假/欺诈信息" value="虚假/欺诈信息" />
            <el-option label="违禁物品" value="违禁物品" />
            <el-option label="价格异常" value="价格异常" />
            <el-option label="图片与实物不符" value="图片与实物不符" />
            <el-option label="垃圾广告/骚扰" value="垃圾广告/骚扰" />
            <el-option label="其他原因" value="其他原因" />
          </el-select>
        </el-form-item>
        <el-form-item label="详细描述">
          <el-input v-model="reportForm.description" type="textarea" :rows="3" placeholder="请详细描述举报原因（选填）" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showReportDialog = false" size="large">取消</el-button>
          <el-button type="danger" @click="handleReport" :loading="reporting" size="large">提交举报</el-button>
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
import { Warning, ArrowLeft, ArrowRight, View, Star, ChatDotRound, ShoppingCart } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const goods = ref(null)
const images = ref([])
const isFavorited = ref(false)
const loading = ref(true)
const currentImageIndex = ref(0)
const showArrow = ref(null)

const sellerName = ref('加载中...')
const sellerCredit = ref('-')

const showOrderDialog = ref(false)
const orderTradeMethod = ref('FACE')
const orderLocation = ref('')
const orderTime = ref(null)
const ordering = ref(false)

// 购买按钮状态文字（根据商品状态动态显示）
const buyStatusText = computed(() => {
  if (!goods.value) return '加载中...'
  const m = { 0: '已下架', 2: '已售出', 3: '审核中', '-1': '已删除' }
  return m[String(goods.value.status)] || '暂不可购买'
})

const showReportDialog = ref(false)
const reporting = ref(false)
const reportForm = ref({
  reason: '',
  description: ''
})

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
    // 保存浏览历史记录
    saveBrowsingHistory()
  } catch (e) {
    goods.value = null
    ElMessage.error('商品加载失败，可能已被删除或下架')
  } finally {
    loading.value = false
  }

function saveBrowsingHistory() {
  const g = goods.value
  if (!g) return

  try {
    const raw = localStorage.getItem('browsing_history')
    let history = raw ? JSON.parse(raw) : []

    // 移除已有的相同 uuid 记录
    history = history.filter(item => item.uuid !== g.uuid)

    // 在头部插入新记录
    history.unshift({
      uuid: g.uuid,
      title: g.title,
      price: g.price,
      coverUrl: images.value.length > 0 ? images.value[0].url : '',
      categoryId: g.categoryId || '',
      viewedAt: new Date().toISOString(),
    })

    // 最多保留 50 条记录
    if (history.length > 50) {
      history = history.slice(0, 50)
    }

    localStorage.setItem('browsing_history', JSON.stringify(history))
  } catch {
    // localStorage 操作失败时静默处理
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

function prevImage() {
  if (images.value.length <= 1) return
  currentImageIndex.value = (currentImageIndex.value - 1 + images.value.length) % images.value.length
}

function nextImage() {
  if (images.value.length <= 1) return
  currentImageIndex.value = (currentImageIndex.value + 1) % images.value.length
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

async function handleReport() {
  if (!reportForm.value.reason) {
    ElMessage.warning('请选择举报原因')
    return
  }
  reporting.value = true
  try {
    await goodsApi.report(goods.value.uuid, {
      reason: reportForm.value.reason,
      description: reportForm.value.description
    })
    ElMessage.success('举报已提交，感谢您的反馈')
    showReportDialog.value = false
    reportForm.value = { reason: '', description: '' }
  } finally {
    reporting.value = false
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
  position: relative;
}

/* 左右切换箭头 */
.img-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  z-index: 10;
  width: 40px;
  height: 40px;
  border: none;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.35);
  color: white;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.25s ease, background 0.2s ease, transform 0.2s ease;
}

.main-image-box:hover .img-arrow {
  opacity: 1;
}

.img-arrow:hover {
  background: rgba(0, 0, 0, 0.6);
  transform: translateY(-50%) scale(1.08);
}

.img-arrow--left { left: 12px; }
.img-arrow--right { right: 12px; }

/* 图片计数 */
.image-counter {
  position: absolute;
  bottom: 10px;
  right: 12px;
  z-index: 10;
  padding: 3px 10px;
  border-radius: var(--sc-radius-full);
  background: rgba(0, 0, 0, 0.45);
  color: white;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.5px;
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

/* 操作按钮组 — 2x2 等宽网格 */
.action-buttons {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.action-btn {
  font-size: 15px;
  font-weight: 600;
  padding: 14px 16px;
  border-radius: var(--sc-radius-md) !important;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  height: auto;
  min-height: 48px;
  letter-spacing: 0.3px;
}

/* 举报 — 次要操作 */
.action-btn--report {
  border: 1.5px solid #F56C6C !important;
  color: #F56C6C !important;
  background: #FEF0F0 !important;
}
.action-btn--report:hover {
  background: #FDE2E2 !important;
  transform: translateY(-2px);
  box-shadow: 0 4px 14px rgba(245, 108, 108, 0.18);
}

/* 收藏 — 次要操作 */
.action-btn--secondary {
  border: 1.5px solid var(--sc-primary) !important;
  color: var(--sc-primary) !important;
  background: transparent !important;
}
.action-btn--secondary:hover {
  background: rgba(232, 90, 79, 0.06) !important;
  transform: translateY(-2px);
  box-shadow: 0 4px 14px rgba(232, 90, 79, 0.15);
}

/* 联系卖家 — 主要操作 */
.action-btn--contact {
  background: var(--sc-primary) !important;
  border-color: var(--sc-primary) !important;
  color: white !important;
}
.action-btn--contact:hover {
  background: var(--sc-primary-dark) !important;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(232, 90, 79, 0.3);
}

/* 立即购买 — CTA 最突出 */
.action-btn--buy {
  background: var(--sc-teal) !important;
  border-color: var(--sc-teal) !important;
  color: white !important;
  font-size: 16px;
  font-weight: 700;
}
.action-btn--buy:hover {
  background: #16A085 !important;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(26, 188, 156, 0.35);
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

/* ===== 举报对话框 ===== */
.report-dialog :deep(.el-dialog) {
  border-radius: 28px !important;
  overflow: hidden;
}

.report-tip {
  color: var(--sc-text-secondary);
  font-size: 14px;
  margin-bottom: 16px;
  line-height: 1.6;
}

.report-form {
  padding: 4px 0;
}
</style>
