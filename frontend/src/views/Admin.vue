<template>
  <div class="admin-page">
    <!-- 仪表盘统计卡片 -->
    <div class="dashboard-header">
      <h1 class="page-title">管理后台</h1>
      <p class="page-subtitle">数据概览与系统管理</p>
    </div>

    <div class="stats-grid">
      <div class="stat-card stat-users">
        <div class="stat-icon">👥</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats[0]?.value || 0 }}</div>
          <div class="stat-label">{{ stats[0]?.label }}</div>
        </div>
      </div>
      <div class="stat-card stat-goods">
        <div class="stat-icon">📦</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats[1]?.value || 0 }}</div>
          <div class="stat-label">{{ stats[1]?.label }}</div>
        </div>
      </div>
      <div class="stat-card stat-orders">
        <div class="stat-icon">🛒</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats[2]?.value || 0 }}</div>
          <div class="stat-label">{{ stats[2]?.label }}</div>
        </div>
      </div>
      <div class="stat-card stat-reports">
        <div class="stat-icon">⚠️</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats[3]?.value || 0 }}</div>
          <div class="stat-label">{{ stats[3]?.label }}</div>
        </div>
      </div>
    </div>

    <!-- 用户管理 -->
    <div class="section-card">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-icon">👤</span>
          用户管理
        </h2>
        <span class="item-count">{{ users.length }} 位用户</span>
      </div>

      <div class="table-wrapper" v-if="users.length > 0">
        <table class="modern-table">
          <thead>
            <tr>
              <th>学号</th>
              <th>用户名</th>
              <th>姓名</th>
              <th>信用分</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(user, index) in users" :key="user.id" :class="{ 'odd-row': index % 2 === 1 }">
              <td>{{ user.studentId }}</td>
              <td class="username-cell">{{ user.username }}</td>
              <td>{{ user.realName }}</td>
              <td class="credit-cell">
                <span class="credit-badge" :class="user.creditScore >= 80 ? 'high' : user.creditScore >= 60 ? 'medium' : 'low'">
                  {{ user.creditScore }}
                </span>
              </td>
              <td>
                <span class="status-tag" :class="'status-' + user.status">
                  {{ user.status === 1 ? '正常' : user.status === 0 ? '禁用' : '待审核' }}
                </span>
              </td>
              <td class="action-cell">
                <button v-if="row.role !== 1" class="toggle-btn" :class="user.status === 1 ? 'disable-btn' : 'enable-btn'" @click="toggleUser(user)">
                  {{ user.status === 1 ? '禁用' : '启用' }}
                </button>
                <span v-else class="admin-badge">管理员</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 举报管理 -->
    <div class="section-card">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-icon">🚨</span>
          举报管理
        </h2>
        <span class="item-count">{{ reports.length }} 条举报</span>
      </div>

      <div class="table-wrapper" v-if="reports.length > 0">
        <table class="modern-table">
          <thead>
            <tr>
              <th>举报原因</th>
              <th>描述</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(report, index) in reports" :key="report.id" :class="{ 'odd-row': index % 2 === 1 }">
              <td class="reason-cell">{{ report.reason }}</td>
              <td class="desc-cell">
                <span class="desc-text">{{ report.description }}</span>
              </td>
              <td>
                <span class="status-tag" :class="'report-status-' + report.status">
                  {{ report.status === 0 ? '待处理' : report.status === 1 ? '已处理' : '已驳回' }}
                </span>
              </td>
              <td class="action-cell">
                <template v-if="report.status === 0">
                  <button class="action-btn handle-btn" @click="handleReport(report, 1)">处理</button>
                  <button class="action-btn reject-btn" @click="handleReport(report, 2)">驳回</button>
                </template>
                <span v-else class="handled-time">{{ report.handledAt?.substring(0, 10) }}</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { adminApi } from '@/api'
import { ElMessage } from 'element-plus'

const stats = ref([
  { label: '用户总数', value: 0 },
  { label: '商品总数', value: 0 },
  { label: '订单总数', value: 0 },
  { label: '待处理举报', value: 0 },
])
const users = ref([])
const reports = ref([])

async function load() {
  try {
    const dash = await adminApi.dashboard()
    stats.value[0].value = dash.totalUsers || 0
    stats.value[1].value = dash.totalGoods || 0
    stats.value[2].value = dash.totalOrders || 0
    stats.value[3].value = dash.pendingReports || 0
  } catch { /* ignore */ }
  try {
    const res = await adminApi.getUsers({ page: 1, size: 50 })
    users.value = res.records || []
  } catch { /* ignore */ }
  try {
    const res = await adminApi.getReports({ page: 1, size: 50 })
    reports.value = res.records || []
  } catch { /* ignore */ }
}

async function toggleUser(row) {
  const newStatus = row.status === 1 ? 0 : 1
  await adminApi.toggleUserStatus(row.id, newStatus)
  ElMessage.success('操作成功')
  row.status = newStatus
}

async function handleReport(row, status) {
  await adminApi.handleReport(row.id, status, '')
  ElMessage.success('处理完成')
  load()
}

onMounted(load)
</script>

<style scoped>
.admin-page {
  max-width: 1200px;
  margin: 0 auto;
}

/* 页面标题 */
.dashboard-header {
  margin-bottom: 28px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0 0 6px;
}

.page-subtitle {
  font-size: 14px;
  color: var(--sc-text-muted);
  margin: 0;
}

/* 统计卡片网格 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 32px;
}

.stat-card {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: var(--sc-shadow-sm);
  transition: all var(--sc-transition);
  position: relative;
  overflow: hidden;
}

.stat-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--sc-shadow-hover);
}

/* 不同卡片的颜色 */
.stat-users::before,
.stat-users .stat-icon {
  background: linear-gradient(135deg, #409EFF, #66B1FF);
}

.stat-users .stat-icon {
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  border-radius: var(--sc-radius-md);
  background: linear-gradient(135deg, rgba(64, 158, 255, 0.12), rgba(102, 177, 255, 0.08));
}

.stat-goods::before,
.stat-goods .stat-icon {
  background: linear-gradient(135deg, var(--sc-primary), var(--sc-primary-light));
}

.stat-goods .stat-icon {
  width: 56px;
  height: 56px;
  border-radius: var(--sc-radius-md);
  background: linear-gradient(135deg, var(--sc-primary-bg), rgba(232, 90, 79, 0.04));
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
}

.stat-orders::before,
.stat-orders .stat-icon {
  background: linear-gradient(135deg, var(--sc-teal), #16A085);
}

.stat-orders .stat-icon {
  width: 56px;
  height: 56px;
  border-radius: var(--sc-radius-md);
  background: linear-gradient(135deg, rgba(26, 188, 156, 0.12), rgba(22, 160, 133, 0.06));
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
}

.stat-reports::before,
.stat-reports .stat-icon {
  background: linear-gradient(135deg, var(--sc-accent), #E67E22);
}

.stat-reports .stat-icon {
  width: 56px;
  height: 56px;
  border-radius: var(--sc-radius-md);
  background: linear-gradient(135deg, rgba(243, 156, 18, 0.12), rgba(230, 126, 34, 0.06));
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: var(--sc-text);
  line-height: 1.2;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 13px;
  color: var(--sc-text-muted);
  font-weight: 500;
}

/* 区块卡片 */
.section-card {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  padding: 24px 28px;
  box-shadow: var(--sc-shadow-md);
  margin-bottom: 24px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 2px solid var(--sc-bg);
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.title-icon {
  font-size: 22px;
}

.item-count {
  font-size: 13px;
  color: var(--sc-text-muted);
  background: var(--sc-bg);
  padding: 4px 12px;
  border-radius: var(--sc-radius-full);
}

/* 表格样式 */
.table-wrapper {
  overflow-x: auto;
}

.modern-table {
  width: 100%;
  border-collapse: collapse;
}

.modern-table thead {
  background: var(--sc-bg-warm);
}

.modern-table th {
  padding: 14px 16px;
  text-align: left;
  font-size: 12px;
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
  transform: scale(1.002);
}

.modern-table tbody tr.odd-row {
  background: #FAFBFC;
}

.modern-table td {
  padding: 14px 16px;
  font-size: 14px;
  color: var(--sc-text);
}

.username-cell {
  font-weight: 500;
  color: var(--sc-secondary);
}

.credit-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: var(--sc-radius-full);
  font-size: 13px;
  font-weight: 600;
}

.credit-badge.high {
  background: #f0f9eb;
  color: #67c23a;
}

.credit-badge.medium {
  background: #fdf6ec;
  color: #e6a23c;
}

.credit-badge.low {
  background: #fef0f0;
  color: #f56c6c;
}

/* 状态标签 */
.status-tag {
  display: inline-block;
  padding: 4px 12px;
  border-radius: var(--sc-radius-full);
  font-size: 12px;
  font-weight: 600;
}

.status-1 {
  background: #f0f9eb;
  color: #67c23a;
}

.status-0 {
  background: #fef0f0;
  color: #f56c6c;
}

.report-status-0 {
  background: #fdf6ec;
  color: #e6a23c;
}

.report-status-1 {
  background: #f0f9eb;
  color: #67c23a;
}

.report-status-2 {
  background: #f4f4f5;
  color: #909399;
}

/* 操作按钮 */
.action-cell {
  white-space: nowrap;
}

.toggle-btn {
  padding: 6px 16px;
  border: none;
  border-radius: var(--sc-radius-sm);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all var(--sc-transition);
}

.disable-btn {
  background: #fef0f0;
  color: #f56c6c;
}

.disable-btn:hover {
  background: #fde2e2;
  transform: translateY(-1px);
}

.enable-btn {
  background: #ecf5ff;
  color: #409eff;
}

.enable-btn:hover {
  background: #d9ecff;
  transform: translateY(-1px);
}

.admin-badge {
  font-size: 12px;
  color: var(--sc-text-muted);
  background: var(--sc-bg);
  padding: 4px 10px;
  border-radius: var(--sc-radius-sm);
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

.handle-btn {
  background: var(--sc-teal);
  color: white;
}

.handle-btn:hover {
  background: #16A085;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(26, 188, 156, 0.25);
}

.reject-btn {
  background: #f4f4f5;
  color: #909399;
}

.reject-btn:hover {
  background: #ebeef5;
  transform: translateY(-1px);
}

.handled-time {
  font-size: 12px;
  color: var(--sc-text-muted);
}

.desc-text {
  max-width: 300px;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.reason-cell {
  font-weight: 500;
}

/* 响应式 */
@media (max-width: 1024px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .modern-table th,
  .modern-table td {
    padding: 10px 12px;
    font-size: 12px;
  }
}
</style>
