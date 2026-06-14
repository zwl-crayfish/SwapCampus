<template>
  <div class="favorites-page">
    <!-- 页面标题 -->
    <div class="page-header">
      <h1 class="page-title">
        <span class="title-icon">❤️</span>
        我的收藏
      </h1>
      <p class="page-subtitle">你喜欢的商品都在这里</p>
    </div>

    <!-- 空状态 -->
    <div v-if="favorites.length === 0" class="empty-state">
      <div class="empty-icon">💝</div>
      <h3>暂无收藏</h3>
      <p>去发现一些心仪的商品吧~</p>
    </div>

    <!-- 商品卡片网格 -->
    <div v-else class="goods-grid">
      <div
        v-for="item in favorites"
        :key="item.uuid"
        class="goods-card"
        @click="$router.push(`/goods/${item.uuid}`)"
      >
        <div class="card-image" v-if="item.imageUrl">
          <img :src="item.imageUrl" :alt="item.title" />
        </div>
        <div class="card-image placeholder-img" v-else>
          <span>📦</span>
        </div>
        <div class="card-content">
          <h3 class="card-title">{{ item.title }}</h3>
          <div class="card-footer">
            <span class="card-price">¥{{ item.price }}</span>
            <span class="favorite-badge">
              <span class="heart-icon">❤️</span>
              已收藏
            </span>
          </div>
        </div>
      </div>
    </div>
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
.favorites-page {
  max-width: 1200px;
  margin: 0 auto;
}

/* 页面标题 */
.page-header {
  text-align: center;
  margin-bottom: 32px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0 0 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.title-icon {
  font-size: 32px;
}

.page-subtitle {
  font-size: 14px;
  color: var(--sc-text-muted);
  margin: 0;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  box-shadow: var(--sc-shadow-sm);
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

/* 商品卡片网格 */
.goods-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}

.goods-card {
  background: var(--sc-white);
  border-radius: var(--sc-radius-md);
  overflow: hidden;
  box-shadow: var(--sc-shadow-sm);
  cursor: pointer;
  transition: all var(--sc-transition);
  border: 1px solid rgba(0, 0, 0, 0.04);
}

.goods-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--sc-shadow-hover);
}

.card-image {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: var(--sc-bg);
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.goods-card:hover .card-image img {
  transform: scale(1.05);
}

.placeholder-img {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 48px;
}

.card-content {
  padding: 16px;
}

.card-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--sc-text);
  margin: 0 0 12px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  min-height: 42px;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-price {
  font-size: 20px;
  font-weight: 700;
  color: var(--sc-primary);
}

.favorite-badge {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: var(--sc-primary);
  background: var(--sc-primary-bg);
  padding: 4px 10px;
  border-radius: var(--sc-radius-full);
  font-weight: 500;
}

.heart-icon {
  font-size: 12px;
}

/* 响应式 */
@media (max-width: 768px) {
  .goods-grid {
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 16px;
  }

  .page-title {
    font-size: 24px;
  }
}
</style>
