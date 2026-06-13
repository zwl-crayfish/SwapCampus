<template>
  <div class="page-container">
    <!-- 分类导航栏 -->
    <div class="category-nav">
      <button
        class="category-tag"
        :class="{ active: selectedCategory === null }"
        @click="selectedCategory = null; handleSearch()"
      >全部</button>
      <button
        v-for="cat in categories"
        :key="cat.id"
        class="category-tag"
        :class="{ active: selectedCategory === cat.id }"
        @click="selectedCategory = cat.id; handleSearch()"
      >{{ cat.name }}</button>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <div class="filter-left">
        <el-select v-model="sortBy" style="width: 130px" @change="handleSearch">
          <el-option label="最新发布" value="created_at" />
          <el-option label="价格排序" value="price" />
        </el-select>
        <div class="sort-btns">
          <button
            class="sort-btn"
            :class="{ active: sortOrder === 'asc' }"
            @click="sortOrder = 'asc'; handleSearch()"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M5 12l7-7 7 7"/></svg>
          </button>
          <button
            class="sort-btn"
            :class="{ active: sortOrder === 'desc' }"
            @click="sortOrder = 'desc'; handleSearch()"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12l7 7 7-7"/></svg>
          </button>
        </div>
      </div>
      <div class="filter-right">
        <span class="total-count">共 <strong>{{ total }}</strong> 件闲置</span>
      </div>
    </div>

    <!-- 商品列表 -->
    <div v-if="loading" class="loading-wrap">
      <el-skeleton :rows="3" animated />
    </div>
    <div v-else-if="goodsList.length === 0" class="empty-wrap">
      <div class="empty-content">
        <div class="empty-icon">📦</div>
        <p class="empty-title">暂无商品</p>
        <p class="empty-desc">换个分类或关键词试试吧～</p>
      </div>
    </div>
    <div v-else class="card-grid stagger">
      <div
        v-for="(item, index) in goodsList"
        :key="item.uuid"
        class="goods-card fade-in-up"
        :style="{ animationDelay: `${index * 0.06}s` }"
        @click="$router.push(`/goods/${item.uuid}`)"
      >
        <div class="goods-image">
          <img
            :src="item.coverUrl || '/placeholder.png'"
            alt=""
            loading="lazy"
            @error="$event.target.src='/placeholder.png'"
          />
          <span v-if="item.conditionLevel >= 9" class="condition-badge">全新</span>
        </div>
        <div class="goods-info">
          <h3 class="goods-title">{{ item.title }}</h3>
          <p class="goods-desc">{{ item.description?.substring(0, 60) || '暂无描述' }}</p>
          <div class="goods-footer">
            <span class="goods-price"><small>¥</small>{{ item.price }}</span>
            <span class="goods-meta">
              <span class="meta-item">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                {{ item.viewCount }}
              </span>
              <span class="meta-item">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                {{ item.favoriteCount }}
              </span>
            </span>
          </div>
        </div>
      </div>
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
import { ref, onMounted, watch } from 'vue'
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

// 监听路由变化（搜索关键词变化时重新加载）
watch(() => route.query.keyword, (newVal, oldVal) => {
  if (newVal !== oldVal) {
    currentPage.value = 1
    handleSearch()
  }
})
</script>

<style scoped>
/* ====== 分类导航栏 ====== */
.category-nav {
  display: flex;
  gap: 10px;
  padding: 6px 4px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
}
.category-nav::-webkit-scrollbar { display: none; }

.category-tag {
  flex-shrink: 0;
  padding: 8px 20px;
  border-radius: var(--sc-radius-full);
  font-size: 14px;
  font-weight: 500;
  color: var(--sc-text-secondary);
  background-color: var(--sc-white);
  border: 1px solid var(--sc-border);
  cursor: pointer;
  transition: var(--sc-transition);
  white-space: nowrap;
}

.category-tag:hover {
  background-color: var(--sc-primary-bg);
  border-color: var(--sc-primary-light);
  color: var(--sc-primary);
}

.category-tag.active {
  background-color: var(--sc-primary);
  color: var(--sc-white);
  border-color: var(--sc-primary);
  box-shadow: 0 4px 12px rgba(232, 90, 79, 0.3);
  font-weight: 600;
}

/* ====== 筛选栏 ====== */
.filter-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding: 14px 20px;
  background: var(--sc-white);
  border-radius: var(--sc-radius-md);
  box-shadow: var(--sc-shadow-sm);
  border: 1px solid var(--sc-border-light);
}

.filter-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.sort-btns {
  display: inline-flex;
  gap: 2px;
  background: var(--sc-bg);
  border-radius: var(--sc-radius-sm);
  padding: 2px;
}

.sort-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 30px;
  border: none;
  border-radius: 6px;
  background: transparent;
  color: var(--sc-text-muted);
  cursor: pointer;
  transition: var(--sc-transition);
}

.sort-btn:hover {
  color: var(--sc-text-secondary);
  background: rgba(255, 255, 255, 0.6);
}

.sort-btn.active {
  background: var(--sc-white);
  color: var(--sc-primary);
  box-shadow: var(--sc-shadow-sm);
  font-weight: 600;
}

.filter-right .total-count {
  font-size: 13px;
  color: var(--sc-text-secondary);
}

.filter-right strong {
  color: var(--sc-primary);
  font-weight: 700;
}

/* ====== 商品卡片网格 ====== */
.goods-card {
  position: relative;
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  box-shadow: var(--sc-shadow-md);
  overflow: hidden;
  cursor: pointer;
  transition: transform 0.35s cubic-bezier(0.34, 1.56, 0.64, 1),
              box-shadow 0.35s ease;
}

.goods-card:hover {
  transform: translateY(-6px) scale(1.02);
  box-shadow: var(--sc-shadow-hover);
}

/* 图片区域 */
.goods-image {
  position: relative;
  width: 100%;
  height: 220px;
  overflow: hidden;
  border-radius: 16px 16px 0 0;
  background: linear-gradient(135deg, #f5f5f5 0%, #e8e8e8 100%);
}

.goods-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.45s ease;
}

.goods-card:hover .goods-image img {
  transform: scale(1.05);
}

.condition-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 4px 12px;
  background: var(--sc-primary);
  color: var(--sc-white);
  font-size: 11px;
  font-weight: 600;
  border-radius: var(--sc-radius-full);
  letter-spacing: 0.03em;
  z-index: 2;
  box-shadow: 0 2px 8px rgba(232, 90, 79, 0.25);
}

/* 商品信息 */
.goods-info {
  padding: 16px 18px 18px;
}

.goods-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--sc-text);
  margin-bottom: 6px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.goods-desc {
  font-size: 12.5px;
  color: var(--sc-text-muted);
  margin-bottom: 14px;
  line-height: 1.55;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 价格行 */
.goods-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid var(--sc-border-light);
}

.goods-price {
  font-size: 22px;
  font-weight: 700;
  color: var(--sc-primary);
  line-height: 1;
}

.goods-price small {
  font-size: 14px;
  font-weight: 600;
  margin-right: 1px;
}

.goods-meta {
  display: flex;
  align-items: center;
  gap: 10px;
}

.meta-item {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  font-size: 12px;
  color: var(--sc-text-muted);
}

.meta-item svg {
  opacity: 0.65;
}

/* ====== 分页 ====== */
.pagination-wrap {
  margin-top: 36px;
  display: flex;
  justify-content: center;
  padding-bottom: 16px;
}

/* ====== 空状态 ====== */
.empty-content {
  text-align: center;
  padding: 60px 20px;
}

.empty-icon {
  font-size: 56px;
  margin-bottom: 16px;
  filter: grayscale(0.2);
}

.empty-title {
  font-size: 17px;
  font-weight: 600;
  color: var(--sc-text-secondary);
  margin-bottom: 6px;
}

.empty-desc {
  font-size: 13px;
  color: var(--sc-text-muted);
}

/* ====== 加载 & 容器 ====== */
.loading-wrap,
.empty-wrap {
  min-height: 360px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* ====== 入场动画 ====== */
@keyframes fadeInUpCard {
  from {
    opacity: 0;
    transform: translateY(24px) scale(0.97);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.fade-in-up {
  animation: fadeInUpCard 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
}
</style>
