<template>
  <div class="page-container">
    <!-- 仪表盘 -->
    <el-row :gutter="20" style="margin-bottom:24px">
      <el-col :span="6" v-for="stat in stats" :key="stat.label">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 用户管理 -->
    <el-card style="margin-bottom:20px">
      <template #header><h3>用户管理</h3></template>
      <el-table :data="users" stripe>
        <el-table-column prop="studentId" label="学号" width="120" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="realName" label="姓名" width="100" />
        <el-table-column prop="creditScore" label="信用分" width="80" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '正常' : row.status === 0 ? '禁用' : '待审核' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="160">
          <template #default="{ row }">
            <el-button size="small" @click="toggleUser(row)" v-if="row.role !== 1">
              {{ row.status === 1 ? '禁用' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 举报管理 -->
    <el-card>
      <template #header><h3>举报管理</h3></template>
      <el-table :data="reports" stripe>
        <el-table-column prop="reason" label="举报原因" width="140" />
        <el-table-column prop="description" label="描述" min-width="200" show-overflow-tooltip />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 0 ? 'warning' : row.status === 1 ? 'success' : 'info'">
              {{ row.status === 0 ? '待处理' : row.status === 1 ? '已处理' : '已驳回' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" v-if="true">
          <template #default="{ row }">
            <template v-if="row.status === 0">
              <el-button size="small" type="primary" @click="handleReport(row, 1)">处理</el-button>
              <el-button size="small" type="info" @click="handleReport(row, 2)">驳回</el-button>
            </template>
            <span v-else style="color:#909399">{{ row.handledAt?.substring(0,10) }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
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
.stat-card { text-align: center; padding: 10px 0; }
.stat-value { font-size: 36px; font-weight: bold; color: #409EFF; }
.stat-label { color: #909399; margin-top: 4px; }
</style>
