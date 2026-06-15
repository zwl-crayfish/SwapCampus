<template>
  <div class="orders-page">
    <!-- 页面标题区 -->
    <div class="page-hero">
      <div class="hero-content">
        <h1 class="page-title">
          <span class="title-icon" v-if="tab === 'buyer'">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
          </span>
          <span class="title-icon" v-else>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
          </span>
          {{ tab === 'buyer' ? '我的购买' : '我的销售' }}
        </h1>
        <p class="page-subtitle">{{ tab === 'buyer' ? '管理你购买的商品订单与评价' : '追踪你卖出的商品与买家反馈' }}</p>
      </div>
    </div>

    <!-- Tab 切换 -->
    <div class="tabs-container">
      <button class="tab-btn" :class="{ active: tab === 'buyer' }" @click="switchTab('buyer')">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
        我购买的
        <span v-if="buyerCount > 0" class="tab-badge">{{ buyerCount }}</span>
      </button>
      <button class="tab-btn" :class="{ active: tab === 'seller' }" @click="switchTab('seller')">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
        我卖出的
        <span v-if="sellerCount > 0" class="tab-badge">{{ sellerCount }}</span>
      </button>
    </div>

    <!-- 空状态 -->
    <div v-if="orders.length === 0 && !loading" class="empty-state">
      <div class="empty-icon">
        <svg width="64" height="64" viewBox="0 0 64 64" fill="none">
          <rect x="8" y="12" width="48" height="40" rx="8" stroke="var(--sc-border)" stroke-width="2"/>
          <path d="M20 28L28 36L44 22" stroke="var(--sc-text-muted)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
      <h3 class="empty-title">暂无订单记录</h3>
      <p class="empty-desc">{{ tab === 'buyer' ? '去逛逛吧，发现校园好物' : '发布闲置，等待你的第一笔交易' }}</p>
      <router-link :to="tab === 'buyer' ? '/' : '/publish'" class="empty-action">
        {{ tab === 'buyer' ? '去逛逛' : '发布闲置' }}
      </router-link>
    </div>

    <!-- 加载状态 -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <span>加载中...</span>
    </div>

    <!-- 订单列表 -->
    <div v-if="!loading && orders.length > 0" class="orders-list">
      <transition-group name="order-fade">
        <div v-for="(order, index) in orders" :key="order.uuid"
             class="order-card"
             :class="'status-' + order.status"
             :style="{ animationDelay: index * 0.05 + 's' }">

          <!-- 订单头部：编号 + 时间 + 状态 -->
          <div class="card-header">
            <div class="header-left">
              <code class="order-code"># {{ order.uuid?.substring(0, 8).toUpperCase() }}</code>
              <span class="order-time">{{ formatTime(order.createdAt) }}</span>
            </div>
            <span class="status-pill" :class="'pill-' + order.status">
              {{ statusText(order.status) }}
            </span>
          </div>

          <!-- 核心信息行 -->
          <div class="card-body">
            <div class="price-block">
              <span class="price-label">交易金额</span>
              <span class="price-value">&yen;{{ Number(order.amount).toFixed(2) }}</span>
            </div>
            <div class="meta-block">
              <div class="meta-item">
                <span class="meta-label">方式</span>
                <span class="meta-tag" :class="order.tradeMethod">
                  {{ order.tradeMethod === 'FACE' ? '面交' : '邮件柜' }}
                </span>
              </div>
              <div v-if="order.meetLocation" class="meta-item">
                <span class="meta-label">地点</span>
                <span class="meta-val">{{ order.meetLocation }}</span>
              </div>
            </div>
          </div>

          <!-- 操作按钮 -->
          <div class="card-actions" v-if="order.status !== 2 && order.status !== -1">
            <button
              v-if="(tab === 'buyer' && order.status === 0) || (tab === 'seller' && order.status === 0)"
              class="action-btn action-btn--primary"
              @click="handleConfirm(order.uuid, tab)"
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
              {{ tab === 'buyer' ? '确认收货' : '确认发货' }}
            </button>
            <button class="action-btn action-btn--ghost" @click="handleCancel(order.uuid)">
              取消订单
            </button>
          </div>

          <!-- ====== 已完成：评价区域 ====== -->
          <div v-if="order.status === 2" class="review-section">

            <!-- 买家评价（我购买的 tab） -->
            <template v-if="tab === 'buyer'">
              <div class="review-card review-card--buyer">
                <div class="review-title-row">
                  <span class="review-icon buyer">B</span>
                  <span>我的评价</span>
                  <span class="review-hint">评价卖家</span>
                </div>
                <!-- 已评价展示 -->
                <div v-if="order.buyerRating" class="review-done">
                  <div class="stars-display">
                    <span v-for="n in 5" :key="n" class="star" :class="{ on: n <= order.buyerRating }">&#9733;</span>
                  </div>
                  <p v-if="order.buyerReview" class="review-text">"{{ order.buyerReview }}"</p>
                  <span class="done-tag">已评价</span>
                </div>
                <!-- 未评价表单 -->
                <div v-else class="review-form-inline">
                  <div class="stars-input">
                    <button v-for="n in 5" :key="n" type="button"
                      class="star-btn"
                      :class="{ active: n <= tempBuyerRating[order.uuid] }"
                      @click="tempBuyerRating[order.uuid] = n"
                    >&#9733;</button>
                  </div>
                  <input type="text" class="review-input" v-model="tempBuyerReview[order.uuid]"
                    placeholder="分享体验（可选）" maxlength="200" />
                  <button class="submit-btn" :disabled="!tempBuyerRating[order.uuid]" @click="submitBuyerReview(order)">提交</button>
                </div>
              </div>

              <!-- 卖家对我的评价（只读） -->
              <div v-if="order.sellerRating" class="review-card review-card--readonly">
                <div class="review-title-row compact">
                  <span class="review-icon seller-sm">S</span>
                  <span>卖家对我的评价</span>
                </div>
                <div class="stars-display sm">
                  <span v-for="n in 5" :key="n" class="star sm" :class="{ on: n <= order.sellerRating }">&#9733;</span>
                </div>
                <p v-if="order.sellerReview" class="review-text sm">"{{ order.sellerReview }}"</p>
              </div>
            </template>

            <!-- 卖家评价（我卖出的 tab） -->
            <template v-if="tab === 'seller'">
              <div class="review-card review-card--seller">
                <div class="review-title-row">
                  <span class="review-icon seller">S</span>
                  <span>评价买家</span>
                  <span class="review-hint">对本次交易的买家做出评价</span>
                </div>
                <!-- 卖家已评价展示 -->
                <div v-if="order.sellerRating" class="review-done">
                  <div class="stars-display stars-teal">
                    <span v-for="n in 5" :key="n" class="star teal" :class="{ on: n <= order.sellerRating }">&#9733;</span>
                  </div>
                  <p v-if="order.sellerReview" class="review-text">"{{ order.sellerReview }}"</p>
                  <span class="done-tag done-teal">已评价买家</span>
                </div>
                <!-- 卖家未评价表单 -->
                <div v-else class="review-form-inline">
                  <div class="stars-input">
                    <button v-for="n in 5" :key="n" type="button"
                      class="star-btn star-btn--teal"
                      :class="{ active: n <= tempSellerRating[order.uuid] }"
                      @click="tempSellerRating[order.uuid] = n"
                    >&#9733;</button>
                  </div>
                  <input type="text" class="review-input" v-model="tempSellerReview[order.uuid]"
                    placeholder="评价买家的信用表现（可选）" maxlength="200" />
                  <button class="submit-btn submit-btn--teal" :disabled="!tempSellerRating[order.uuid]" @click="submitSellerReview(order)">评价买家</button>
                </div>
              </div>

              <!-- 买家对我的评价（只读） -->
              <div v-if="order.buyerRating" class="review-card review-card--readonly">
                <div class="review-title-row compact">
                  <span class="review-icon buyer-sm">B</span>
                  <span>买家对我的评价</span>
                </div>
                <div class="stars-display sm">
                  <span v-for="n in 5" :key="n" class="star sm" :class="{ on: n <= order.buyerRating }">&#9733;</span>
                </div>
                <p v-if="order.buyerReview" class="review-text sm">"{{ order.buyerReview }}"</p>
              </div>
            </template>

          </div><!-- /review-section -->
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { orderApi } from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'

const tab = ref('buyer')
const orders = ref([])
const loading = ref(false)
const buyerCount = ref(0)
const sellerCount = ref(0)

// 临时评价数据（按订单uuid索引）
const tempBuyerRating = reactive({})
const tempBuyerReview = reactive({})
const tempSellerRating = reactive({})
const tempSellerReview = reactive({})

async function switchTab(t) {
  if (tab.value === t) return
  tab.value = t
  await loadOrders()
}

async function loadOrders() {
  loading.value = true
  try {
    const api = tab.value === 'buyer' ? orderApi.buyerOrders : orderApi.sellerOrders
    const res = await api({ page: 1, size: 50 })
    orders.value = res.records || []
    if (tab.value === 'buyer') buyerCount.value = orders.value.length
    else sellerCount.value = orders.value.length
  } catch { /* ignore */ }
  finally { loading.value = false }
}

async function handleConfirm(uuid, role) {
  try {
    const api = role === 'buyer' ? orderApi.buyerConfirm : orderApi.sellerConfirm
    await api(uuid)
    ElMessage.success(role === 'buyer' ? '确认收货成功，交易完成！' : '确认成功')
    loadOrders()
  } catch { /* ignore */ }
}

async function handleCancel(uuid) {
  await ElMessageBox.confirm('确定要取消这个订单吗？', '取消订单', {
    confirmButtonText: '确定取消',
    cancelButtonText: '再想想',
    type: 'warning',
  })
  try {
    await orderApi.cancel(uuid)
    ElMessage.success('订单已取消')
    loadOrders()
  } catch { /* ignore */ }
}

async function submitBuyerReview(order) {
  const rating = tempBuyerRating[order.uuid]
  const review = tempBuyerReview[order.uuid]?.trim()
  if (!rating) return
  try {
    await orderApi.review(order.uuid, rating, review || null)
    ElMessage.success('评价提交成功！')
    order.buyerRating = rating
    order.buyerReview = review
    delete tempBuyerRating[order.uuid]
    delete tempBuyerReview[order.uuid]
  } catch { /* ignore */ }
}

async function submitSellerReview(order) {
  const rating = tempSellerRating[order.uuid]
  const review = tempSellerReview[order.uuid]?.trim()
  if (!rating) return
  try {
    await orderApi.sellerReview(order.uuid, rating, review || null)
    ElMessage.success('评价提交成功！')
    order.sellerRating = rating
    order.sellerReview = review
    delete tempSellerRating[order.uuid]
    delete tempSellerReview[order.uuid]
  } catch { /* ignore */ }
}

function formatTime(timeStr) {
  if (!timeStr) return ''
  return timeStr.replace('T', ' ').substring(0, 16)
}

function statusText(status) {
  const map = { '-1': '已取消', '0': '待确认', '1': '进行中', '2': '已完成', '3': '退货中' }
  return map[status] || '未知'
}

onMounted(loadOrders)
</script>

<style scoped>
/* ========== 容器 & 布局 ========== */
.orders-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px;
}

/* ========== 页面英雄区 ========== */
.page-hero {
  margin-bottom: 20px;
  padding: 24px 28px;
  background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
  border-radius: 16px;
}
.hero-content { position: relative; }
.page-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 20px;
  font-weight: 700;
  color: #f1f5f9;
  margin: 0 0 4px;
}
.title-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  background: rgba(255,255,255,0.08);
  border-radius: 10px;
  color: #f87171;
  flex-shrink: 0;
}
.page-subtitle {
  font-size: 13px;
  color: #94a3b8;
  margin: 0;
  padding-left: 48px;
}

/* ========== Tab 切换 ========== */
.tabs-container {
  display: flex;
  gap: 4px;
  margin-bottom: 18px;
  background: #fff;
  padding: 4px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}
.tab-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 11px 18px;
  background: transparent;
  border: none;
  border-radius: 9px;
  font-size: 13.5px;
  font-weight: 600;
  color: #64748b;
  cursor: pointer;
  transition: all 0.25s ease;
}
.tab-btn:hover { color: #334155; }
.tab-btn.active {
  background: #ef4444;
  color: #fff;
  box-shadow: 0 2px 8px rgba(239,68,68,0.3);
}
.tab-badge {
  font-size: 11px;
  font-weight: 700;
  background: rgba(255,255,255,0.22);
  padding: 1px 7px;
  border-radius: 8px;
  min-width: 18px;
  text-align: center;
}
.tab-btn:not(.active) .tab-badge {
  background: #f1f5f9;
  color: #94a3b8;
}

/* ========== 空状态 ========== */
.empty-state {
  text-align: center;
  padding: 56px 20px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.04);
}
.empty-icon { margin-bottom: 16px; opacity: 0.5; }
.empty-title {
  font-size: 16px;
  font-weight: 600;
  color: #334155;
  margin: 0 0 6px;
}
.empty-desc {
  font-size: 13px;
  color: #94a3b8;
  margin: 0 0 18px;
}
.empty-action {
  display: inline-block;
  padding: 10px 26px;
  background: linear-gradient(135deg, #ef4444, #dc2626);
  color: #fff;
  border-radius: 10px;
  font-weight: 600;
  font-size: 13px;
  text-decoration: none;
  transition: transform 0.2s, box-shadow 0.2s;
}
.empty-action:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 14px rgba(239,68,68,0.3);
}

/* ========== 加载状态 ========== */
.loading-state {
  text-align: center;
  padding: 48px 20px;
  background: #fff;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: #94a3b8;
  font-size: 13px;
}
.loading-spinner {
  width: 30px;
  height: 30px;
  border: 3px solid #e2e8f0;
  border-top-color: #ef4444;
  border-radius: 50%;
  animation: spin 0.65s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ========== 订单列表 ========== */
.orders-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* ========== 订单卡片 ========== */
.order-card {
  background: #fff;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  transition: box-shadow 0.25s ease, transform 0.25s ease;
  border: 1px solid #f1f5f9;
  animation: slideUp 0.4s ease both;
}
@keyframes slideUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}
.order-card:hover {
  box-shadow: 0 4px 16px rgba(0,0,0,0.07);
}

/* 左侧色条 */
.order-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
}
.order-card.status-0::before { background: linear-gradient(180deg, #f59e0b, #fbbf24); }
.order-card.status-1::before { background: linear-gradient(180deg, #3b82f6, #60a5fa); }
.order-card.status-2::before { background: linear-gradient(180deg, #22c55e, #4ade80); }
.order-card.status--1::before,
.order-card.status-3::before { background: #d1d5db; }

/* 卡片头部 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 18px;
  border-bottom: 1px dashed #e2e8f0;
}
.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}
.order-code {
  font-size: 12px;
  font-weight: 700;
  color: #334155;
  font-family: 'SF Mono', Consolas, monospace;
  letter-spacing: 0.8px;
  background: #f8fafc;
  padding: 2px 8px;
  border-radius: 5px;
}
.order-time {
  font-size: 12px;
  color: #94a3b8;
}

/* 状态药丸 */
.status-pill {
  font-size: 11.5px;
  font-weight: 700;
  padding: 4px 12px;
  border-radius: 20px;
  letter-spacing: 0.3px;
}
.pill--1, .pill-3 { background: #f1f5f9; color: #94a3b8; }
.pill-0 { background: #fef3c7; color: #d97706; }
.pill-1 { background: #dbeafe; color: #2563eb; }
.pill-2 { background: #dcfce7; color: #16a34a; }

/* 卡片主体 */
.card-body {
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 16px 18px;
}
.price-block {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex-shrink: 0;
}
.price-label {
  font-size: 10.5px;
  text-transform: uppercase;
  letter-spacing: 1px;
  color: #94a3b8;
  font-weight: 600;
}
.price-value {
  font-size: 24px;
  font-weight: 800;
  color: #ef4444;
  letter-spacing: -0.5px;
}
.meta-block {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}
.meta-item {
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.meta-label {
  font-size: 10.5px;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  color: #94a3b8;
  font-weight: 600;
}
.meta-tag {
  font-size: 12.5px;
  font-weight: 600;
  padding: 2px 10px;
  border-radius: 6px;
  display: inline-block;
  width: fit-content;
}
.meta-tag.FACE { background: #eff6ff; color: #2563eb; }
.meta-tag.LOCKER { background: #fffbeb; color: #d97706; }
.meta-val {
  font-size: 13px;
  font-weight: 500;
  color: #475569;
  max-width: 160px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 操作按钮区 */
.card-actions {
  display: flex;
  gap: 8px;
  padding: 12px 18px;
  border-top: 1px solid #f1f5f9;
}
.action-btn {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  padding: 8px 18px;
  border: none;
  border-radius: 8px;
  font-size: 12.5px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
}
.action-btn:disabled { opacity: 0.45; cursor: not-allowed; }
.action-btn--primary {
  background: linear-gradient(135deg, #0ea5e9, #0284c7);
  color: #fff;
  box-shadow: 0 2px 8px rgba(14,165,233,0.25);
}
.action-btn--primary:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(14,165,233,0.35);
}
.action-btn--ghost {
  background: #f8fafc;
  color: #64748b;
}
.action-btn--ghost:hover {
  background: #fee2e2;
  color: #ef4444;
}

/* ========== 评价区域 ========== */
.review-section {
  margin-top: 0;
  border-top: 1.5px solid #f1f5f9;
  padding: 14px 18px 16px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

/* 评价卡片 */
.review-card {
  border-radius: 10px;
  overflow: hidden;
}
.review-card--buyer {
  background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 40%);
  border: 1px solid rgba(245,158,11,0.12);
}
.review-card--seller {
  background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 40%);
  border: 1px solid rgba(16,185,129,0.12);
}
.review-card--readonly {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  padding: 10px 14px;
}

/* 评价标题行 */
.review-title-row {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px 0;
  font-size: 13px;
  font-weight: 700;
  color: #334155;
}
.review-title-row.compact {
  padding: 6px 10px 0;
  font-size: 12px;
  font-weight: 600;
}
.review-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 26px;
  height: 26px;
  border-radius: 7px;
  font-size: 12px;
  font-weight: 800;
  flex-shrink: 0;
}
.review-icon.buyer { background: #fde68a; color: #b45309; }
.review-icon.seller { background: #a7f3d0; color: #047857; }
.review-icon.buyer-sm { width: 22px; height: 22px; border-radius: 6px; font-size: 10px; background: #fef3c7; color: #b45309; }
.review-icon.seller-sm { width: 22px; height: 22px; border-radius: 6px; font-size: 10px; background: #d1fae5; color: #047857; }
.review-hint {
  font-size: 11px;
  font-weight: 400;
  color: #94a3b8;
  margin-left: auto;
}

/* 星星展示 */
.review-done {
  padding: 10px 14px 12px;
}
.stars-display {
  display: flex;
  gap: 2px;
  margin-bottom: 6px;
}
.stars-display.sm { gap: 1px; }
.star {
  font-size: 18px;
  line-height: 1;
  color: #e2e8f0;
}
.star.on { color: #f59e0b; }
.star.teal.on { color: #10b981; }
.star.sm { font-size: 14px; }
.stars-teal .star.teal { color: #10b981; }
.review-text {
  font-size: 12.5px;
  color: #64748b;
  font-style: italic;
  margin: 0 0 6px;
  line-height: 1.55;
}
.review-text.sm { font-size: 11.5px; }
.done-tag {
  display: inline-block;
  font-size: 10.5px;
  font-weight: 700;
  padding: 2px 10px;
  border-radius: 6px;
  background: rgba(245,158,11,0.1);
  color: #b45309;
}
.done-teal {
  background: rgba(16,185,129,0.1);
  color: #047857;
}

/* 评价表单（紧凑内联） */
.review-form-inline {
  padding: 10px 14px 12px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}
.stars-input {
  display: flex;
  gap: 2px;
}
.star-btn {
  background: none;
  border: none;
  font-size: 22px;
  color: #d1d5db;
  cursor: pointer;
  padding: 1px;
  line-height: 1;
  transition: transform 0.15s, color 0.15s;
}
.star-btn:hover { transform: scale(1.2); }
.star-btn.active { color: #f59e0b; text-shadow: 0 0 8px rgba(245,158,11,0.35); }
.star-btn--teal.active { color: #10b981; text-shadow: 0 0 8px rgba(16,185,129,0.35); }
.review-input {
  flex: 1;
  min-width: 140px;
  padding: 7px 12px;
  border: 1.5px solid #e2e8f0;
  border-radius: 8px;
  font-size: 12.5px;
  color: #334155;
  outline: none;
  transition: border-color 0.2s;
  font-family: inherit;
  box-sizing: border-box;
}
.review-input:focus { border-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245,158,11,0.08); }
.submit-btn {
  padding: 7px 16px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 700;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
  white-space: nowrap;
}
.submit-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 3px 10px rgba(245,158,11,0.3);
}
.submit-btn:disabled { opacity: 0.4; cursor: not-allowed; }
.submit-btn--teal {
  background: linear-gradient(135deg, #10b981, #059669);
}
.submit-btn--teal:hover:not(:disabled) {
  box-shadow: 0 3px 10px rgba(16,185,129,0.3);
}

/* ========== 过渡动画 ========== */
.order-fade-enter-active,
.order-fade-leave-active {
  transition: all 0.3s ease;
}
.order-fade-enter-from,
.order-fade-leave-to {
  opacity: 0;
  transform: translateX(-12px);
}

/* ========== 响应式 ========== */
@media (max-width: 640px) {
  .orders-page { padding: 0 10px; }
  .page-hero { padding: 18px 18px; border-radius: 12px; }
  .page-title { font-size: 17px; }
  .page-subtitle { padding-left: 0; margin-top: 6px; }
  .title-icon { width: 32px; height: 32px; border-radius: 8px; }

  .tabs-container { border-radius: 10px; }
  .tab-btn { padding: 10px 12px; font-size: 12.5px; }

  .card-header { flex-direction: column; align-items: flex-start; gap: 8px; padding: 12px 14px; }
  .card-body { flex-direction: column; align-items: flex-start; gap: 12px; padding: 12px 14px; }
  .meta-block { width: 100%; gap: 14px; }
  .price-value { font-size: 22px; }
  .card-actions { flex-wrap: wrap; }

  .review-form-inline { flex-direction: column; align-items: stretch; }
  .review-input { min-width: unset; }
  .submit-btn { width: 100%; }
}
</style>
