<template>
  <div class="page-container">
    <el-card>
      <template #header>
        <div style="display:flex;justify-content:space-between;align-items:center">
          <h2>我发布的商品</h2>
          <el-button type="primary" @click="$router.push('/publish')">发布新商品</el-button>
        </div>
      </template>
      <el-table :data="goodsList" stripe>
        <el-table-column prop="title" label="标题" min-width="200" />
        <el-table-column prop="price" label="价格" width="100">
          <template #default="{ row }">¥{{ row.price }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="statusTag(row.status)">{{ statusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="浏览" width="80" />
        <el-table-column prop="createdAt" label="发布时间" width="160">
          <template #default="{ row }">{{ row.createdAt?.substring(0, 10) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" @click="$router.push(`/publish/${row.uuid}`)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleOffShelf(row)">下架</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
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
