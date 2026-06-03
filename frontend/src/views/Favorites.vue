<template>
  <div class="page-container">
    <el-card>
      <template #header><h2>我的收藏</h2></template>
      <div v-if="favorites.length === 0">
        <el-empty description="暂无收藏" />
      </div>
      <div v-else class="card-grid">
        <el-card v-for="item in favorites" :key="item.uuid" class="goods-card" shadow="hover" @click="$router.push(`/goods/${item.uuid}`)">
          <h3>{{ item.title }}</h3>
          <p style="color:#f56c6c;font-size:18px;font-weight:bold">¥{{ item.price }}</p>
        </el-card>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { goodsApi } from '@/api'

const favorites = ref([])
onMounted(async () => {
  try {
    const res = await goodsApi.list({ page: 1, size: 50 })
    favorites.value = (res.records || []).filter(g => g.favoriteCount > 0)
  } catch { /* ignore */ }
})
</script>

<style scoped>
.goods-card { cursor: pointer; }
.goods-card:hover { transform: translateY(-2px); }
</style>
