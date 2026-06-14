<template>
  <div class="orders-page">
    <!-- Tab 切换 -->
    <div class="tabs-container">
      <button
        class="tab-btn"
        :class="{ active: tab === 'buyer' }"
        @click="tab = 'buyer'; loadOrders()"
      >
        <span class="tab-icon">🛒</span>
        我购买的
      </button>
      <button
        class="tab-btn"
        :class="{ active: tab === 'seller' }"
        @click="tab = 'seller'; loadOrders()"
      >
        <span class="tab-icon">💰</span>
        我卖出的
      </button>
    </div>

    <!-- 空状态 -->
    <div v-if="orders.length === 0" class="empty-state">
      <div class="empty-icon">📋</div>
      <h3>暂无订单</h3>
      <p>{{ tab === 'buyer' ? '你还没有购买任何商品' : '你还没有卖出任何商品' }}</p>
    </div>

    <!-- 订单列表 -->
    <div v-else class="orders-list">
      <div v-for="order in orders" :key="order.uuid" class="order-card" :class="'status-' + order.status">
        <!-- 左侧状态色条 -->
        <div class="status-bar"></div>

        <!-- 内容区 -->
        <div class="order-content">
          <!-- 订单头部 -->
          <div class="order-header">
            <div class="order-info">
              <span class="order-id">订单号: {{ order.uuid?.substring(0, 12) }}...</span>
              <span class="order-time">{{ order.createdAt?.substring(0, 16) }}</span>
            </div>
            <span class="order-status" :class="'tag-' + order.status">{{ statusText(order.status) }}</span>
          </div>

          <!-- 订单详情 -->
          <div class="order-details">
            <div class="detail-item">
              <span class="detail-label">金额</span>
              <span class="detail-value amount">¥{{ order.amount }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">交易方式</span>
              <span class="detail-value">{{ order.tradeMethod === 'FACE' ? '面交' : '邮件柜' }}</span>
            </div>
            <div v-if="order.meetLocation" class="detail-item">
              <span class="detail-label">地点</span>
              <span class="detail-value location">{{ order.meetLocation }}</span>
            </div>
          </div>

          <!-- 操作按钮 -->
          <div class="order-actions" v-if="order.status !== 2 && order.status !== -1">
            <button
              v-if="tab === 'buyer' && order.status === 0"
              class="action-btn confirm-btn"
              @click="handleConfirm(order.uuid, 'buyer')"
            >
              ✓ 确认收货
            </button>
            <button
              v-if="tab === 'seller' && order.status === 0"
              class="action-btn confirm-btn"
              @click="handleConfirm(order.uuid, 'seller')"
            >
              ✓ 确认交易
            </button>
            <button class="action-btn cancel-btn" @click="handleCancel(order.uuid)">
              ✕ 取消订单
            </button>
          </div>

          <!-- 评价区域 -->
          <div v-if="order.status === 2 && order.buyerRating" class="review-section">
            <div class="rating-display">
              <span class="stars">{{ '★'.repeat(order.buyerRating) }}{{ '☆'.repeat(5 - order.buyerRating) }}</span>
              <span class="score">{{ order.buyerRating }}.0 分</span>
            </div>
            <p v-if="order.buyerReview" class="review-text">{{ order.buyerReview }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { orderApi } from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

const tab = ref('buyer')
const orders = ref([])

async function loadOrders() {
  try {
    const api = tab.value === 'buyer' ? orderApi.buyerOrders : orderApi.sellerOrders
    const res = await api({ page: 1, size: 50 })
    orders.value = res.records || []
  } catch { /* ignore */ }
}

async function handleConfirm(uuid, role) {
  try {
    const api = role === 'buyer' ? orderApi.buyerConfirm : orderApi.sellerConfirm
    await api(uuid)
    ElMessage.success('确认成功')
    loadOrders()
  } catch { /* ignore */ }
}

async function handleCancel(uuid) {
  await ElMessageBox.confirm('确定取消订单吗？', '提示', { type: 'warning' })
  try {
    await orderApi.cancel(uuid)
    ElMessage.success('已取消')
    loadOrders()
  } catch { /* ignore */ }
}

function statusTag(status) {
  const map = { '-1': 'danger', '0': 'warning', '1': 'primary', '2': 'success', '3': 'danger' }
  return map[status] || 'info'
}
function statusText(status) {
  const map = { '-1': '已取消', '0': '待确认', '1': '进行中', '2': '已完成', '3': '退货中' }
  return map[status] || '未知'
}

onMounted(loadOrders)
</script>

<style scoped>
.orders-page {
  max-width: 900px;
  margin: 0 auto;
}

/* Tab 切换 */
.tabs-container {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  background: var(--sc-white);
  padding: 6px;
  border-radius: var(--sc-radius-lg);
  box-shadow: var(--sc-shadow-sm);
}

.tab-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 14px 24px;
  background: transparent;
  border: none;
  border-radius: var(--sc-radius-md);
  font-size: 15px;
  font-weight: 600;
  color: var(--sc-text-secondary);
  cursor: pointer;
  transition: all var(--sc-transition);
}

.tab-btn:hover {
  background: var(--sc-bg);
  color: var(--sc-text);
}

.tab-btn.active {
  background: var(--sc-primary);
  color: white;
  box-shadow: 0 4px 12px rgba(232, 90, 79, 0.25);
}

.tab-icon {
  font-size: 18px;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  box-shadow: var(--sc-shadow-sm);
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 16px;
}

.empty-state h3 {
  font-size: 18px;
  font-weight: 600;
  color: var(--sc-text-secondary);
  margin: 0 0 8px;
}

.empty-state p {
  font-size: 14px;
  color: var(--sc-text-muted);
  margin: 0;
}

/* 订单列表 */
.orders-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* 订单卡片 */
.order-card {
  display: flex;
  background: var(--sc-white);
  border-radius: var(--sc-radius-md);
  overflow: hidden;
  box-shadow: var(--sc-shadow-sm);
  transition: all var(--sc-transition);
  border: 1px solid rgba(0, 0, 0, 0.04);
}

.order-card:hover {
  box-shadow: var(--sc-shadow-hover);
  transform: translateY(-2px);
}

/* 左侧状态色条 */
.status-bar {
  width: 4px;
  flex-shrink: 0;
}

/* 不同状态的色条颜色 */
.order-card.status--1 .status-bar,
.order-card.status-3 .status-bar {
  background: #909399;
}

.order-card.status-0 .status-bar {
  background: #e6a23c;
}

.order-card.status-1 .status-bar {
  background: #409eff;
}

.order-card.status-2 .status-bar {
  background: #67c23a;
}

/* 内容区 */
.order-content {
  flex: 1;
  padding: 20px 24px;
}

/* 订单头部 */
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.order-id {
  font-size: 13px;
  font-weight: 500;
  color: var(--sc-text-secondary);
  font-family: monospace;
}

.order-time {
  font-size: 12px;
  color: var(--sc-text-muted);
}

/* 状态标签 */
.order-status {
  padding: 6px 14px;
  border-radius: var(--sc-radius-full);
  font-size: 13px;
  font-weight: 600;
}

.tag--1, .tag-3 {
  background: #f4f4f5;
  color: #909399;
}

.tag-0 {
  background: #fdf6ec;
  color: #e6a23c;
}

.tag-1 {
  background: #ecf5ff;
  color: #409eff;
}

.tag-2 {
  background: #f0f9eb;
  color: #67c23a;
}

/* 订单详情 */
.order-details {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.detail-label {
  font-size: 12px;
  color: var(--sc-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-weight: 500;
}

.detail-value {
  font-size: 15px;
  font-weight: 500;
  color: var(--sc-text);
}

.detail-value.amount {
  font-size: 22px;
  font-weight: 700;
  color: var(--sc-primary);
}

.detail-value.location {
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 操作按钮 */
.order-actions {
  display: flex;
  gap: 10px;
  padding-top: 16px;
  border-top: 1px solid rgba(0, 0, 0, 0.06);
}

.action-btn {
  padding: 8px 20px;
  border: none;
  border-radius: var(--sc-radius-sm);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all var(--sc-transition);
}

.confirm-btn {
  background: var(--sc-teal);
  color: white;
}

.confirm-btn:hover {
  background: #16A085;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(26, 188, 156, 0.25);
}

.cancel-btn {
  background: #fef0f0;
  color: #f56c6c;
}

.cancel-btn:hover {
  background: #fde2e2;
  transform: translateY(-1px);
}

/* 评价区域 */
.review-section {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid rgba(0, 0, 0, 0.06);
}

.rating-display {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}

.stars {
  font-size: 18px;
  color: var(--sc-accent);
  letter-spacing: 2px;
}

.score {
  font-size: 14px;
  font-weight: 600;
  color: var(--sc-accent);
}

.review-text {
  font-size: 13px;
  color: var(--sc-text-secondary);
  line-height: 1.6;
  margin: 0;
  padding-left: 28px;
  font-style: italic;
}

/* 响应式 */
@media (max-width: 768px) {
  .tabs-container {
    flex-direction: column;
  }

  .order-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .order-details {
    grid-template-columns: 1fr;
  }

  .order-actions {
    flex-wrap: wrap;
  }
}
</style>
