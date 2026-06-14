<template>
  <div class="mygoods-page">
    <!-- 顶部操作栏 -->
    <div class="page-toolbar">
      <div class="toolbar-left">
        <h1 class="page-title">我发布的商品</h1>
        <span class="item-count">共 {{ goodsList.length }} 件商品</span>
      </div>
      <button class="publish-btn" @click="$router.push('/publish')">
        <span class="btn-icon">+</span>
        发布新商品
      </button>
    </div>

    <!-- 商品表格 -->
    <div class="table-container">
      <table class="modern-table" v-if="goodsList.length > 0">
        <thead>
          <tr>
            <th>商品信息</th>
            <th>价格</th>
            <th>状态</th>
            <th>浏览量</th>
            <th>发布时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(row, index) in goodsList" :key="row.uuid" :class="{ 'odd-row': index % 2 === 1 }">
            <td class="title-cell">
              <span class="goods-title">{{ row.title }}</span>
            </td>
            <td class="price-cell">¥{{ row.price }}</td>
            <td class="status-cell">
              <span class="status-tag" :class="'status-' + row.status">{{ statusText(row.status) }}</span>
            </td>
            <td class="views-cell">
              <span class="view-count">👁️ {{ row.viewCount }}</span>
            </td>
            <td class="time-cell">{{ row.createdAt?.substring(0, 10) }}</td>
            <td class="actions-cell">
              <button class="action-btn edit-btn" @click="$router.push(`/publish/${row.uuid}`)">
                编辑
              </button>
              <button class="action-btn delete-btn" @click="handleOffShelf(row)" :disabled="row.status === -1 || row.status === 2">
                下架
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- 空状态 -->
      <div v-else class="empty-state">
        <div class="empty-icon">📦</div>
        <h3>暂无发布的商品</h3>
        <p>点击上方按钮发布你的第一个商品吧~</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { goodsApi } from '@/api'
import { ElMessage } from 'element-plus'

const goodsList = ref([])

async function load() {
  try {
    const res = await goodsApi.myPublished({ page: 1, size: 50 })
    goodsList.value = res.records || []
  } catch { /* ignore */ }
}

async function handleOffShelf(row) {
  try {
    await goodsApi.changeStatus(row.uuid, 0)
    ElMessage.success('已下架')
    load()
  } catch { /* ignore */ }
}

function statusTag(s) {
  return { '-1': 'info', '0': 'warning', '1': 'success', '2': 'danger', '3': 'warning' }[s] || 'info'
}
function statusText(s) {
  return { '-1': '已删除', '0': '已下架', '1': '在售', '2': '已售出', '3': '审核中' }[s] || s
}

onMounted(load)
</script>

<style scoped>
.mygoods-page {
  max-width: 1200px;
  margin: 0 auto;
}

/* 顶部工具栏 */
.page-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding: 20px 28px;
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  box-shadow: var(--sc-shadow-sm);
}

.toolbar-left {
  display: flex;
  align-items: baseline;
  gap: 12px;
}

.page-title {
  font-size: 24px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0;
}

.item-count {
  font-size: 14px;
  color: var(--sc-text-muted);
}

.publish-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 10px 24px;
  background: var(--sc-primary);
  color: white;
  border: none;
  border-radius: var(--sc-radius-sm);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all var(--sc-transition);
  box-shadow: 0 4px 12px rgba(232, 90, 79, 0.25);
}

.publish-btn:hover {
  background: #d94d43;
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(232, 90, 79, 0.35);
}

.btn-icon {
  font-size: 18px;
  font-weight: 400;
}

/* 表格容器 */
.table-container {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  overflow: hidden;
  box-shadow: var(--sc-shadow-md);
}

/* 现代化表格 */
.modern-table {
  width: 100%;
  border-collapse: collapse;
}

.modern-table thead {
  background: var(--sc-bg-warm);
}

.modern-table th {
  padding: 16px 20px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: var(--sc-text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid var(--sc-primary-bg);
}

.modern-table tbody tr {
  transition: all var(--sc-transition);
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);
}

.modern-table tbody tr:hover {
  background: var(--sc-bg);
  transform: scale(1.005);
  box-shadow: inset 0 0 0 1px var(--sc-primary-bg);
}

.modern-table tbody tr.odd-row {
  background: #FAFBFC;
}

.modern-table td {
  padding: 16px 20px;
  font-size: 14px;
  color: var(--sc-text);
}

/* 单元格样式 */
.goods-title {
  font-weight: 500;
  max-width: 250px;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.price-cell {
  font-weight: 700;
  color: var(--sc-primary);
  font-size: 16px !important;
}

/* 状态标签 */
.status-tag {
  display: inline-block;
  padding: 4px 12px;
  border-radius: var(--sc-radius-full);
  font-size: 12px;
  font-weight: 600;
}

.status--1 {
  background: #f4f4f5;
  color: #909399;
}

.status-0 {
  background: #fdf6ec;
  color: #e6a23c;
}

.status-1 {
  background: #f0f9eb;
  color: #67c23a;
}

.status-2 {
  background: #fef0f0;
  color: #f56c6c;
}

.status-3 {
  background: #fdf6ec;
  color: #e6a23c;
}

.views-cell {
  color: var(--sc-text-secondary);
}

.time-cell {
  color: var(--sc-text-muted);
  font-size: 13px;
}

/* 操作按钮 */
.actions-cell {
  white-space: nowrap;
}

.action-btn {
  padding: 6px 14px;
  border: none;
  border-radius: var(--sc-radius-sm);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all var(--sc-transition);
  margin-right: 6px;
}

.edit-btn {
  background: var(--sc-teal);
  color: white;
}

.edit-btn:hover {
  background: #16A085;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(26, 188, 156, 0.3);
}

.delete-btn {
  background: #fef0f0;
  color: #f56c6c;
}

.delete-btn:hover:not(:disabled) {
  background: #fde2e2;
  transform: translateY(-1px);
}

.delete-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
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

/* 响应式 */
@media (max-width: 768px) {
  .page-toolbar {
    flex-direction: column;
    gap: 16px;
    align-items: stretch;
    text-align: center;
  }

  .toolbar-left {
    justify-content: center;
  }

  .modern-table {
    font-size: 12px;
  }

  .modern-table th,
  .modern-table td {
    padding: 12px 10px;
  }

  .goods-title {
    max-width: 150px;
  }
}
</style>
