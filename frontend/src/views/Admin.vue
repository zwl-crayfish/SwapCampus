<template>
  <div class="admin-page">
    <!-- 仪表盘统计卡片 -->
    <div class="dashboard-header">
      <h1 class="page-title">管理后台</h1>
      <p class="page-subtitle">数据概览与系统管理</p>
    </div>

    <el-tabs v-model="activeTab" class="admin-tabs">
      <!-- Tab1: 数据概览 -->
      <el-tab-pane label="数据概览" name="overview">
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
      </el-tab-pane>

      <!-- Tab2: 用户管理 -->
      <el-tab-pane label="用户管理" name="users">
        <div class="section-card">
          <div class="section-header">
            <h2 class="section-title">
              <span class="title-icon">👤</span>
              用户管理
            </h2>
            <div class="header-actions">
              <el-input
                v-model="userSearch"
                placeholder="搜索用户名/学号..."
                clearable
                prefix-icon="Search"
                style="width: 240px;"
                @input="filterUsers"
              />
              <span class="item-count">{{ filteredUsers.length }} 位用户</span>
            </div>
          </div>

          <div class="table-wrapper" v-if="filteredUsers.length > 0">
            <table class="modern-table">
              <thead>
                <tr>
                  <th>学号</th>
                  <th>用户名</th>
                  <th>姓名</th>
                  <th>信用分</th>
                  <th>注册时间</th>
                  <th>状态</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(user, index) in filteredUsers" :key="user.id" :class="{ 'odd-row': index % 2 === 1 }">
                  <td>{{ user.studentId }}</td>
                  <td class="username-cell">{{ user.username }}</td>
                  <td>{{ user.realName }}</td>
                  <td class="credit-cell">
                    <span class="credit-badge" :class="user.creditScore >= 80 ? 'high' : user.creditScore >= 60 ? 'medium' : 'low'">
                      {{ user.creditScore }}
                    </span>
                  </td>
                  <td>{{ formatTime(user.createdAt) }}</td>
                  <td>
                    <span class="status-tag" :class="'status-' + user.status">
                      {{ user.status === 1 ? '正常' : user.status === 0 ? '禁用' : '待审核' }}
                    </span>
                  </td>
                  <td class="action-cell">
                    <button class="action-btn detail-btn" @click="showUserDetail(user)">详情</button>
                    <button v-if="user.role !== 1" class="toggle-btn" :class="user.status === 1 ? 'disable-btn' : 'enable-btn'" @click="toggleUser(user)">
                      {{ user.status === 1 ? '禁用' : '启用' }}
                    </button>
                    <span v-else class="admin-badge">管理员</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else class="empty-state">
            <p>暂无用户数据</p>
          </div>
        </div>
      </el-tab-pane>

      <!-- Tab3: 商品审核 -->
      <el-tab-pane label="商品审核" name="review">
        <div class="section-card">
          <div class="section-header">
            <h2 class="section-title">
              <span class="title-icon">✅</span>
              商品审核
            </h2>
            <span class="item-count">{{ reviewGoods.length }} 条待审核</span>
          </div>

          <div class="table-wrapper" v-if="reviewGoods.length > 0">
            <table class="modern-table review-table">
              <thead>
                <tr>
                  <th>商品图片</th>
                  <th>商品名称</th>
                  <th>价格</th>
                  <th>发布者</th>
                  <th>分类</th>
                  <th>发布时间</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in reviewGoods" :key="item.goods.uuid" :class="{ 'odd-row': index % 2 === 1 }">
                  <td class="thumb-cell">
                    <el-image
                      :src="item.goods.coverImage || ''"
                      fit="cover"
                      class="review-thumb"
                    >
                      <template #error>
                        <div class="thumb-placeholder"><img src="/placeholder.png" alt="暂无图片" /></div>
                      </template>
                    </el-image>
                  </td>
                  <td class="goods-title-cell">
                    <span class="goods-title-text" :title="item.goods.title">{{ item.goods.title }}</span>
                  </td>
                  <td class="price-cell">
                    <span class="review-price">&yen;{{ item.goods.price }}</span>
                  </td>
                  <td class="seller-cell">
                    <span class="seller-name">{{ item.sellerName }}</span>
                    <span class="seller-id">{{ item.sellerId }}</span>
                  </td>
                  <td>{{ item.goods.categoryId || '-' }}</td>
                  <td>{{ formatTime(item.goods.createdAt) }}</td>
                  <td class="action-cell audit-actions">
                    <button class="action-btn approve-btn" @click="auditItem(item, 1)">通过</button>
                    <button class="action-btn reject-audit-btn" @click="showRejectDialog(item)">驳回</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else class="empty-state empty-review">
            <div class="empty-icon">🎉</div>
            <p class="empty-title">暂无待审核商品</p>
            <p class="empty-desc">所有商品均已审核完毕</p>
          </div>
        </div>
      </el-tab-pane>

      <!-- Tab4: 举报管理 -->
      <el-tab-pane label="举报管理" name="reports">
        <div class="section-card">
          <div class="section-header">
            <h2 class="section-title">
              <span class="title-icon">🚨</span>
              举报管理
            </h2>
            <span class="item-count">{{ reports.length }} 条举报</span>
          </div>

          <div class="table-wrapper" v-if="reports.length > 0">
            <table class="modern-table report-table">
              <thead>
                <tr>
                  <th>举报人</th>
                  <th>被举报商品</th>
                  <th>举报原因</th>
                  <th>描述</th>
                  <th>举报时间</th>
                  <th>状态</th>
                  <th>处理备注</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(report, index) in reports" :key="report.id" :class="{ 'odd-row': index % 2 === 1 }">
                  <td class="reporter-cell">{{ report.reporterUsername || report.reporterId || '-' }}</td>
                  <td class="goods-cell">
                    <a v-if="report.goodsUuid" class="goods-link" @click="goToGoods(report.goodsUuid)">
                      {{ report.goodsTitle || '查看商品' }}
                    </a>
                    <span v-else>-</span>
                  </td>
                  <td class="reason-cell">{{ report.reason }}</td>
                  <td class="desc-cell">
                    <span class="desc-text" :title="report.description">{{ report.description }}</span>
                  </td>
                  <td>{{ formatTime(report.createdAt) }}</td>
                  <td>
                    <span class="status-tag" :class="'report-status-' + report.status">
                      {{ report.status === 0 ? '待处理' : report.status === 1 ? '已处理' : '已驳回' }}
                    </span>
                  </td>
                  <td class="remark-cell">
                    <span v-if="report.status !== 0" class="remark-text" :title="report.remark">
                      {{ report.remark || '-' }}
                    </span>
                    <span v-else class="no-remark">-</span>
                  </td>
                  <td class="action-cell">
                    <template v-if="report.status === 0">
                      <button class="action-btn handle-btn" @click="handleReport(report, 1)">处理</button>
                      <button class="action-btn reject-btn" @click="handleReport(report, 2)">驳回</button>
                    </template>
                    <span v-else class="handled-time">{{ formatTime(report.handledAt) }}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else class="empty-state">
            <p>暂无举报记录</p>
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>

    <!-- 用户详情弹窗 -->
    <el-dialog v-model="detailVisible" title="用户详情" width="500px" class="detail-dialog">
      <div class="detail-content" v-if="currentUser">
        <div class="detail-item">
          <span class="detail-label">学号：</span>
          <span class="detail-value">{{ currentUser.studentId }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">用户名：</span>
          <span class="detail-value">{{ currentUser.username }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">姓名：</span>
          <span class="detail-value">{{ currentUser.realName }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">信用分：</span>
          <span class="credit-badge" :class="currentUser.creditScore >= 80 ? 'high' : currentUser.creditScore >= 60 ? 'medium' : 'low'">
            {{ currentUser.creditScore }}
          </span>
        </div>
        <div class="detail-item">
          <span class="detail-label">注册时间：</span>
          <span class="detail-value">{{ formatTime(currentUser.createdAt) }}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">状态：</span>
          <span class="status-tag" :class="'status-' + currentUser.status">
            {{ currentUser.status === 1 ? '正常' : currentUser.status === 0 ? '禁用' : '待审核' }}
          </span>
        </div>
      </div>
    </el-dialog>

    <!-- 驳回审核弹窗 -->
    <el-dialog v-model="rejectVisible" title="驳回审核" width="440px" class="reject-dialog">
      <div class="reject-content">
        <p v-if="currentReviewItem" class="reject-goods-name">商品：{{ currentReviewItem.goods.title }}</p>
        <p class="reject-hint">请填写驳回原因（将通知发布者）：</p>
        <el-input
          v-model="rejectRemark"
          type="textarea"
          :rows="3"
          placeholder="如：图片与描述不符、价格异常、涉嫌违规等..."
          maxlength="200"
          show-word-limit
        />
      </div>
      <template #footer>
        <button class="dialog-btn cancel-dialog-btn" @click="rejectVisible = false">取消</button>
        <button class="dialog-btn confirm-reject-btn" @click="confirmReject">确认驳回</button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { adminApi } from '@/api'
import { ElMessage } from 'element-plus'

const router = useRouter()
const activeTab = ref('overview')
const userSearch = ref('')
const detailVisible = ref(false)
const currentUser = ref(null)

const stats = ref([
  { label: '用户总数', value: 0 },
  { label: '商品总数', value: 0 },
  { label: '订单总数', value: 0 },
  { label: '待处理举报', value: 0 },
])
const users = ref([])
const reports = ref([])
const reviewGoods = ref([])
const rejectVisible = ref(false)
const currentReviewItem = ref(null)
const rejectRemark = ref('')

const filteredUsers = computed(() => {
  if (!userSearch.value.trim()) return users.value
  const keyword = userSearch.value.toLowerCase().trim()
  return users.value.filter(u =>
    (u.username && u.username.toLowerCase().includes(keyword)) ||
    (u.studentId && u.studentId.toLowerCase().includes(keyword))
  )
})

function formatTime(timeStr) {
  if (!timeStr) return '-'
  return timeStr.substring(0, 16).replace('T', ' ')
}

function filterUsers() {
  // 响应式计算属性自动过滤
}

function showUserDetail(user) {
  currentUser.value = user
  detailVisible.value = true
}

function goToGoods(uuid) {
  router.push(`/goods/${uuid}`)
}

async function load() {
  try {
    const [dashRes, usersRes, reportsRes, reviewRes] = await Promise.allSettled([
      adminApi.dashboard(),
      adminApi.getUsers({ page: 1, size: 50 }),
      adminApi.getReports({ page: 1, size: 50 }),
      adminApi.getReviewGoods({ page: 1, size: 50 }),
    ])

    if (dashRes.status === 'fulfilled') {
      const dash = dashRes.value
      stats.value[0].value = dash.totalUsers || 0
      stats.value[1].value = dash.totalGoods || 0
      stats.value[2].value = dash.totalOrders || 0
      stats.value[3].value = dash.pendingReports || 0
    } else {
      ElMessage.error('加载统计数据失败')
    }

    if (usersRes.status === 'fulfilled') {
      const res = usersRes.value
      users.value = Array.isArray(res.records) ? res.records : (Array.isArray(res) ? res : [])
    } else {
      ElMessage.error('加载用户列表失败')
    }

    if (reportsRes.status === 'fulfilled') {
      const res = reportsRes.value
      reports.value = Array.isArray(res.records) ? res.records : (Array.isArray(res) ? res : [])
    } else {
      ElMessage.error('加载举报列表失败')
    }

    if (reviewRes.status === 'fulfilled') {
      const res = reviewRes.value
      reviewGoods.value = Array.isArray(res.records) ? res.records : []
    }
  } catch (err) {
    console.error('加载数据失败:', err)
    ElMessage.error('加载数据失败，请刷新页面重试')
  }
}

async function toggleUser(row) {
  const newStatus = row.status === 1 ? 0 : 1
  await adminApi.toggleUserStatus(row.id, newStatus)
  ElMessage.success('操作成功')
  row.status = newStatus
}

async function handleReport(row, status) {
  await adminApi.handleReport(row.id, status, '')
  ElMessage.success(status === 1 ? '处理完成' : '已驳回')
  load()
}

// 商品审核
async function auditItem(item, status) {
  await adminApi.auditGoods(item.goods.uuid, status)
  ElMessage.success(status === 1 ? '已通过审核，商品已上架' : '已驳回')
  load()
}

function showRejectDialog(item) {
  currentReviewItem.value = item
  rejectRemark.value = ''
  rejectVisible.value = true
}

async function confirmReject() {
  if (!currentReviewItem.value) return
  await adminApi.auditGoods(currentReviewItem.value.goods.uuid, 0, rejectRemark.value || '不符合平台规范')
  ElMessage.success('已驳回，已通知发布者')
  rejectVisible.value = false
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

/* Tabs 样式 */
.admin-tabs {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  box-shadow: var(--sc-shadow-md);
  padding: 20px 24px;
}

.admin-tabs :deep(.el-tabs__header) {
  margin-bottom: 24px;
  border-bottom: 2px solid var(--sc-bg);
}

.admin-tabs :deep(.el-tabs__item) {
  font-size: 15px;
  font-weight: 600;
  color: var(--sc-text-muted);
  padding: 0 24px;
  height: 44px;
  line-height: 44px;
  transition: all var(--sc-transition);
}

.admin-tabs :deep(.el-tabs__item.is-active) {
  color: var(--sc-primary);
  font-weight: 700;
}

.admin-tabs :deep(.el-tabs__item:hover) {
  color: var(--sc-primary);
}

.admin-tabs :deep(.el-tabs__active-bar) {
  background-color: var(--sc-primary);
  height: 3px;
  border-radius: 2px;
}

/* 统计卡片网格 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
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
  border-radius: var(--sc-radius-lg);
  padding: 8px 0;
  box-shadow: none;
  margin-bottom: 0;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 2px solid var(--sc-bg);
  flex-wrap: wrap;
  gap: 12px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
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

.detail-btn {
  background: #ecf5ff;
  color: #409eff;
}

.detail-btn:hover {
  background: #d9ecff;
  transform: translateY(-1px);
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
  max-width: 200px;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.reason-cell {
  font-weight: 500;
}

/* 举报表格特殊列 */
.reporter-cell {
  font-weight: 500;
  color: var(--sc-secondary);
}

.goods-link {
  color: var(--sc-primary);
  cursor: pointer;
  font-weight: 500;
  text-decoration: underline;
  text-decoration-style: dotted;
}

.goods-link:hover {
  color: var(--sc-primary-light);
}

.remark-cell {
  max-width: 150px;
}

.remark-text {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 13px;
  color: var(--sc-text-secondary);
}

.no-remark {
  color: var(--sc-text-muted);
  font-size: 13px;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 48px 20px;
  color: var(--sc-text-muted);
  font-size: 15px;
}

/* 详情弹窗 */
.detail-content {
  padding: 8px 0;
}

.detail-item {
  display: flex;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid var(--sc-bg);
}

.detail-item:last-child {
  border-bottom: none;
}

.detail-label {
  width: 90px;
  font-size: 14px;
  color: var(--sc-text-secondary);
  font-weight: 600;
  flex-shrink: 0;
}

.detail-value {
  font-size: 14px;
  color: var(--sc-text);
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

  .header-actions {
    width: 100%;
    flex-direction: column;
    align-items: stretch;
  }

  .header-actions .el-input {
    width: 100% !important;
  }

  .modern-table th,
  .modern-table td {
    padding: 10px 12px;
    font-size: 12px;
  }

  .report-table {
    min-width: 800px;
  }

  .review-table {
    min-width: 700px;
  }
}

/* ===== 商品审核表格样式 ===== */
.review-thumb {
  width: 52px;
  height: 52px;
  border-radius: var(--sc-radius-sm);
  border: 1.5px solid var(--sc-border);
  display: block;
}

.thumb-placeholder {
  width: 52px;
  height: 52px;
  border-radius: var(--sc-radius-sm);
  background: var(--sc-bg);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
}

.thumb-cell {
  width: 60px;
}

.goods-title-cell {
  max-width: 200px;
}

.goods-title-text {
  font-weight: 500;
  color: var(--sc-text);
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.price-cell {
  font-weight: 700;
}

.review-price {
  color: var(--sc-primary);
  font-size: 15px;
}

.seller-cell {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.seller-name {
  font-weight: 500;
  color: var(--sc-secondary);
  font-size: 13px;
}

.seller-id {
  font-size: 11px;
  color: var(--sc-text-muted);
}

/* 审核操作按钮 */
.audit-actions {
  white-space: nowrap;
}

.approve-btn {
  background: linear-gradient(135deg, #67c23a, #85ce61);
  color: white;
  border: none;
  box-shadow: 0 2px 8px rgba(103, 194, 58, 0.25);
}

.approve-btn:hover {
  background: linear-gradient(135deg, #529b2e, #67c23a);
  transform: translateY(-1px);
  box-shadow: 0 3px 12px rgba(103, 194, 58, 0.35);
}

.reject-audit-btn {
  background: #fef0f0;
  color: #f56c6c;
  border: none;
}

.reject-audit-btn:hover {
  background: #fde2e2;
  transform: translateY(-1px);
}

/* 审核空状态 */
.empty-review {
  text-align: center;
  padding: 48px 20px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.empty-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--sc-text);
  margin-bottom: 4px;
}

.empty-desc {
  font-size: 13px;
  color: var(--sc-text-muted);
  margin: 0;
}

/* 驳回弹窗 */
.reject-content {
  padding: 4px 0;
}

.reject-goods-name {
  font-weight: 600;
  color: var(--sc-primary);
  margin: 0 0 10px;
  font-size: 14px;
}

.reject-hint {
  font-size: 13px;
  color: var(--sc-text-secondary);
  margin: 0 0 12px;
}

.dialog-btn {
  padding: 9px 24px;
  border: none;
  border-radius: var(--sc-radius-sm);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.cancel-dialog-btn {
  background: var(--sc-bg);
  color: var(--sc-text-secondary);
}

.cancel-dialog-btn:hover {
  background: var(--sc-border);
}

.confirm-reject-btn {
  background: var(--sc-primary);
  color: white;
  margin-left: 8px;
}

.confirm-reject-btn:hover {
  background: var(--sc-primary-light);
  transform: translateY(-1px);
}
</style>
