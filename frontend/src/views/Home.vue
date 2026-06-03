<template>
  <div class="page-container">
    <!-- 分类导航 -->
    <div class="category-bar">
      <el-radio-group v-model="selectedCategory" size="large" @change="handleSearch">
        <el-radio-button :value="null">全部</el-radio-button>
        <el-radio-button v-for="cat in categories" :key="cat.id" :value="cat.id">
          {{ cat.name }}
        </el-radio-button>
      </el-radio-group>
    </div>

    <!-- 筛选排序 -->
    <div class="filter-bar">
      <div class="filter-left">
        <el-select v-model="sortBy" style="width: 120px" @change="handleSearch">
          <el-option label="最新发布" value="created_at" />
          <el-option label="价格排序" value="price" />
        </el-select>
        <el-button :type="sortOrder === 'asc' ? 'primary' : ''" @click="sortOrder = 'asc'; handleSearch()">
          <el-icon><SortUp /></el-icon>
        </el-button>
        <el-button :type="sortOrder === 'desc' ? 'primary' : ''" @click="sortOrder = 'desc'; handleSearch()">
          <el-icon><SortDown /></el-icon>
        </el-button>
      </div>
      <div class="filter-right">
        <el-text type="info">共 {{ total }} 件闲置</el-text>
      </div>
    </div>

    <!-- 商品列表 -->
    <div v-if="loading" class="loading-wrap">
      <el-skeleton :rows="3" animated />
    </div>
    <div v-else-if="goodsList.length === 0" class="empty-wrap">
      <el-empty description="暂无商品" />
    </div>
    <div v-else class="card-grid">
      <el-card
        v-for="item in goodsList"
        :key="item.uuid"
        class="goods-card"
        shadow="hover"
        @click="$router.push(`/goods/${item.uuid}`)"
      >
        <div class="goods-image">
          <el-image
            :src="item.coverUrl || '/placeholder.png'"
            fit="cover"
            style="width:100%;height:200px"
            lazy
          >
            <template #error>
              <div class="image-placeholder">
                <el-icon :size="48"><PictureFilled /></el-icon>
              </div>
            </template>
          </el-image>
          <el-tag v-if="item.conditionLevel >= 9" type="success" size="small" class="condition-tag">全新</el-tag>
        </div>
        <div class="goods-info">
          <h3 class="goods-title">{{ item.title }}</h3>
          <p class="goods-desc">{{ item.description?.substring(0, 60) || '暂无描述' }}</p>
          <div class="goods-footer">
            <span class="goods-price">¥{{ item.price }}</span>
            <span class="goods-meta">
              <el-icon><View /></el-icon> {{ item.viewCount }}
              <el-icon style="margin-left:8px"><Star /></el-icon> {{ item.favoriteCount }}
            </span>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 分页 -->
    <div class="pagination-wrap" v-if="total > pageSize">
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="total"
        layout="prev, pager, next"
        @current-change="handleSearch"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { goodsApi, categoryApi } from '@/api'

const route = useRoute()

const goodsList = ref([])
const categories = ref([])
const total = ref(0)
const loading = ref(true)
const currentPage = ref(1)
const pageSize = ref(12)
const selectedCategory = ref(null)
const sortBy = ref('created_at')
const sortOrder = ref('desc')

async function handleSearch() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      size: pageSize.value,
      keyword: route.query.keyword || null,
      categoryId: selectedCategory.value,
      sortBy: sortBy.value,
      sortOrder: sortOrder.value,
    }
    const res = await goodsApi.list(params)
    goodsList.value = res.records || []
    total.value = res.total || 0
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  // 加载分类
  try {
    const res = await categoryApi.list()
    categories.value = res || []
  } catch { /* ignore */ }
  handleSearch()
})
</script>

<style scoped>
.category-bar {
  margin-bottom: 16px;
  overflow-x: auto;
  white-space: nowrap;
}
.filter-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.filter-left {
  display: flex;
  gap: 8px;
  align-items: center;
}
.goods-card {
  cursor: pointer;
  transition: transform 0.2s;
}
.goods-card:hover {
  transform: translateY(-4px);
}
.goods-image {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
}
.image-placeholder {
  width: 100%;
  height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f0f0f0;
  color: #c0c4cc;
}
.condition-tag {
  position: absolute;
  top: 8px;
  right: 8px;
}
.goods-info {
  padding: 12px 0 0;
}
.goods-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 6px;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.goods-desc {
  font-size: 13px;
  color: #909399;
  margin-bottom: 12px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.goods-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.goods-price {
  font-size: 20px;
  font-weight: bold;
  color: #f56c6c;
}
.goods-meta {
  font-size: 12px;
  color: #c0c4cc;
  display: flex;
  align-items: center;
}
.pagination-wrap {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}
.loading-wrap, .empty-wrap {
  min-height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
