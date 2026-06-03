<template>
  <div class="page-container">
    <el-card>
      <template #header>
        <el-tabs v-model="tab" @tab-change="loadOrders">
          <el-tab-pane label="我购买的" name="buyer" />
          <el-tab-pane label="我卖出的" name="seller" />
        </el-tabs>
      </template>
      <div v-if="orders.length === 0">
        <el-empty description="暂无订单" />
      </div>
      <div v-else class="order-list">
        <div v-for="order in orders" :key="order.uuid" class="order-card">
          <div class="order-header">
            <span>订单号: {{ order.uuid }}</span>
            <el-tag :type="statusTag(order.status)">{{ statusText(order.status) }}</el-tag>
          </div>
          <div class="order-body">
            <div>
              <span class="order-label">金额:</span> ¥{{ order.amount }}
            </div>
            <div>
              <span class="order-label">方式:</span>
              {{ order.tradeMethod === 'FACE' ? '面交' : '邮件柜' }}
            </div>
            <div v-if="order.meetLocation">
              <span class="order-label">地点:</span> {{ order.meetLocation }}
            </div>
            <div>
              <span class="order-label">时间:</span> {{ order.createdAt?.substring(0, 16) }}
            </div>
          </div>
          <div class="order-actions" v-if="order.status !== 2 && order.status !== -1">
            <el-button
              v-if="tab === 'buyer' && order.status === 0"
              type="primary" @click="handleConfirm(order.uuid, 'buyer')"
            >确认收货</el-button>
            <el-button
              v-if="tab === 'seller' && order.status === 0"
              type="primary" @click="handleConfirm(order.uuid, 'seller')"
            >确认交易</el-button>
            <el-button @click="handleCancel(order.uuid)">取消订单</el-button>
          </div>
          <div v-if="order.status === 2 && order.buyerRating">
            <el-rate :model-value="order.buyerRating" disabled show-score />
            <p style="color:#909399;font-size:13px">{{ order.buyerReview }}</p>
          </div>
        </div>
      </div>
    </el-card>
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
.order-list { display: flex; flex-direction: column; gap: 12px; }
.order-card {
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  padding: 16px;
}
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  font-size: 14px;
  color: #606266;
}
.order-body { display: flex; flex-wrap: wrap; gap: 8px 24px; font-size: 14px; }
.order-label { color: #909399; }
.order-actions { margin-top: 12px; display: flex; gap: 8px; }
</style>
