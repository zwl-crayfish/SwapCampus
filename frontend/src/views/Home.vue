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
          <el-option label="浏览量排序" value="viewCount" />
          <el-option label="收藏数排序" value="favoriteCount" />
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
        <!-- 高级筛选按钮 -->
        <button
          class="advanced-filter-btn"
          :class="{ active: showAdvancedFilter }"
          @click="showAdvancedFilter = !showAdvancedFilter"
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
          <span>高级筛选</span>
          <span v-if="activeFilterCount > 0" class="filter-badge">{{ activeFilterCount }}</span>
        </button>
      </div>
      <div class="filter-right">
        <button
          v-if="activeFilterCount > 0"
          class="clear-filter-btn"
          @click="clearAllFilters"
        >
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
          清除筛选
        </button>
        <span class="total-count">共 <strong>{{ total }}</strong> 件闲置</span>
      </div>
    </div>

    <!-- 高级筛选面板 -->
    <transition name="panel-slide">
      <div v-if="showAdvancedFilter" class="advanced-panel">
        <div class="panel-inner">
          <div class="filter-grid">
            <!-- 价格区间 -->
            <div class="filter-group price-group">
              <label class="filter-label">💰 价格区间</label>
              <div class="price-inputs">
                <el-input-number
                  v-model="priceMin"
                  :min="0"
                  :precision="0"
                  :controls="false"
                  placeholder="最低价"
                  size="small"
                  style="width: 120px"
                />
                <span class="price-separator">—</span>
                <el-input-number
                  v-model="priceMax"
                  :min="0"
                  :precision="0"
                  :controls="false"
                  placeholder="最高价"
                  size="small"
                  style="width: 120px"
                />
              </div>
            </div>

            <!-- 商品状态 -->
            <div class="filter-group status-group">
              <label class="filter-label">📦 商品状态</label>
              <div class="chip-row">
                <button
                  v-for="st in statusOptions"
                  :key="st.value"
                  class="chip-btn chip-status"
                  :class="{ active: selectedStatus === st.value }"
                  @click="toggleStatus(st.value)"
                >{{ st.label }}</button>
              </div>
            </div>

            <!-- 上架时间 -->
            <div class="filter-group time-group">
              <label class="filter-label">🕐 上架时间</label>
              <div class="chip-row">
                <button
                  v-for="t in timeOptions"
                  :key="t.value"
                  class="chip-btn chip-time"
                  :class="{ active: selectedTime === t.value }"
                  @click="toggleTime(t.value)"
                >{{ t.label }}</button>
              </div>
            </div>

            <!-- 浏览量 -->
            <div class="filter-group view-group">
              <label class="filter-label">👁️ 浏览量</label>
              <div class="chip-row">
                <button
                  v-for="v in viewOptions"
                  :key="v.value"
                  class="chip-btn chip-view"
                  :class="{ active: selectedView === v.value }"
                  @click="selectedView = selectedView === v.value ? (v.value === null ? null : null) : v.value"
                >{{ v.label }}</button>
              </div>
            </div>

            <!-- 收藏数 -->
            <div class="filter-group fav-group">
              <label class="filter-label">⭐ 收藏数</label>
              <div class="chip-row">
                <button
                  v-for="f in favoriteOptions"
                  :key="f.value"
                  class="chip-btn chip-fav"
                  :class="{ active: selectedFavorite === f.value }"
                  @click="selectedFavorite = selectedFavorite === f.value ? (f.value === null ? null : null) : f.value"
                >{{ f.label }}</button>
              </div>
            </div>

            <!-- 成色等级 -->
            <div class="filter-group condition-group full-width">
              <label class="filter-label">✨ 成色等级 ({{ conditionRange[0] }} - {{ conditionRange[1] }})</label>
              <div class="slider-wrap">
                <el-slider
                  v-model="conditionRange"
                  range
                  :min="1"
                  :max="10"
                  :step="1"
                  :marks="conditionMarks"
                  :show-tooltip="true"
                />
              </div>
            </div>
          </div>

          <div class="panel-footer">
            <button class="apply-btn" @click="applyFilters">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              应用筛选
            </button>
          </div>
        </div>
      </div>
    </transition>

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
          <!-- 商品状态标签 -->
          <span
            v-if="item.status != null && item.status !== 1"
            class="status-badge"
            :class="{ 'status--off_shelf': item.status === 0, 'status--sold_out': item.status === 2, 'status--reviewing': item.status === 3 }"
          >{{ getStatusLabel(item.status) }}</span>
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
import { ref, computed, onMounted, watch } from 'vue'
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

// ====== 高级筛选相关状态 ======
const showAdvancedFilter = ref(false)

// 价格区间
const priceMin = ref(null)
const priceMax = ref(null)

// 商品状态（与后端 Goods.status 一致：0=下架, 1=在售, 2=已售出）
const statusOptions = [
  { label: '在售', value: 1 },
  { label: '已下架', value: 0 },
  { label: '已售出', value: 2 },
]
const selectedStatus = ref(null)

// 上架时间
const timeOptions = [
  { label: '今天', value: 'today' },
  { label: '一周内', value: 'week' },
  { label: '一月内', value: 'month' },
  { label: '三月内', value: 'threeMonth' },
]
const selectedTime = ref(null)

// 浏览量
const viewOptions = [
  { label: '不限', value: null },
  { label: '10+', value: 10 },
  { label: '50+', value: 50 },
  { label: '100+', value: 100 },
  { label: '500+', value: 500 },
]
const selectedView = ref(null)

// 收藏数
const favoriteOptions = [
  { label: '不限', value: null },
  { label: '1+', value: 1 },
  { label: '5+', value: 5 },
  { label: '10+', value: 10 },
]
const selectedFavorite = ref(null)

// 成色等级
const conditionRange = ref([1, 10])
const conditionMarks = {
  1: '1',
  5: '5',
  10: '10',
}

// 计算激活的筛选条件数量
const activeFilterCount = computed(() => {
  let count = 0
  if (priceMin.value !== null) count++
  if (priceMax.value !== null) count++
  if (selectedStatus.value) count++
  if (selectedTime.value) count++
  if (selectedView.value !== null && selectedView.value !== undefined) count++
  if (selectedFavorite.value !== null && selectedFavorite.value !== undefined) count++
  if (conditionRange.value[0] !== 1 || conditionRange.value[1] !== 10) count++
  return count
})

// 切换函数（单选可取消）
function toggleStatus(val) {
  selectedStatus.value = selectedStatus.value === val ? null : val
}
function toggleTime(val) {
  selectedTime.value = selectedTime.value === val ? null : val
}

function getStatusLabel(status) {
  const map = { 0: '已下架', 1: '在售', 2: '已售出', 3: '审核中' }
  return map[status] || ''
}

// 应用筛选
function applyFilters() {
  currentPage.value = 1
  handleSearch()
}

// 清除所有筛选
function clearAllFilters() {
  priceMin.value = null
  priceMax.value = null
  selectedStatus.value = null
  selectedTime.value = null
  selectedView.value = null
  selectedFavorite.value = null
  conditionRange.value = [1, 10]
  currentPage.value = 1
  handleSearch()
}

async function handleSearch() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      size: pageSize.value,
      keyword: route.query.keyword || null,
      categoryId: selectedCategory.value,
      sortBy: sortBy.value === 'viewCount' ? 'view_count'
            : sortBy.value === 'favoriteCount' ? 'favorite_count'
            : sortBy.value,
      sortOrder: sortOrder.value,
      // 高级筛选参数（与后端 PageQuery 字段名一致）
      minPrice: priceMin.value ?? undefined,
      maxPrice: priceMax.value ?? undefined,
      status: selectedStatus.value ?? undefined,
      timeRange: selectedTime.value ?? undefined,
      viewMin: selectedView.value ?? undefined,
      favMin: selectedFavorite.value ?? undefined,
      conditionMin: conditionRange.value[0] !== 1 ? conditionRange.value[0] : undefined,
      conditionMax: conditionRange.value[1] !== 10 ? conditionRange.value[1] : undefined,
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
  margin-bottom: 16px;
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

/* 高级筛选按钮 */
.advanced-filter-btn {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  padding: 7px 14px;
  border-radius: var(--sc-radius-full);
  font-size: 13px;
  font-weight: 500;
  color: var(--sc-text-secondary);
  background: linear-gradient(135deg, #f8f0ff 0%, #f0f4ff 100%);
  border: 1px solid #d8c8f0;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  white-space: nowrap;
}

.advanced-filter-btn:hover {
  background: linear-gradient(135deg, #ede0fa 0%, #e0e8ff 100%);
  border-color: #c4a8e8;
  color: var(--sc-text);
  transform: translateY(-1px);
  box-shadow: 0 3px 10px rgba(138, 90, 200, 0.15);
}

.advanced-filter-btn.active {
  background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);
  color: #fff;
  border-color: transparent;
  box-shadow: 0 4px 14px rgba(99, 102, 241, 0.35);
}

.advanced-filter-btn.active svg {
  opacity: 1;
}

.advanced-filter-btn svg {
  flex-shrink: 0;
  opacity: 0.75;
}

.filter-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  border-radius: 9px;
  font-size: 11px;
  font-weight: 700;
  background: var(--sc-primary);
  color: #fff;
  line-height: 1;
}

.advanced-filter-btn.active .filter-badge {
  background: rgba(255, 255, 255, 0.9);
  color: #6366f1;
}

/* 清除筛选按钮 */
.clear-filter-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 5px 12px;
  border-radius: var(--sc-radius-full);
  font-size: 12px;
  font-weight: 500;
  color: var(--sc-text-muted);
  background: var(--sc-bg);
  border: 1px solid var(--sc-border);
  cursor: pointer;
  transition: all 0.25s ease;
  margin-right: 12px;
}

.clear-filter-btn:hover {
  color: var(--sc-primary);
  border-color: var(--sc-primary-light);
  background: var(--sc-primary-bg);
}

.filter-right {
  display: flex;
  align-items: center;
}

.filter-right .total-count {
  font-size: 13px;
  color: var(--sc-text-secondary);
}

.filter-right strong {
  color: var(--sc-primary);
  font-weight: 700;
}

/* ====== 高级筛选面板 ====== */
.advanced-panel {
  margin-bottom: 24px;
  overflow: hidden;
}

.panel-inner {
  background: var(--sc-white);
  border-radius: var(--sc-radius-lg);
  box-shadow: var(--sc-shadow-md);
  border: 1px solid var(--sc-border-light);
  padding: 24px 28px 20px;
  position: relative;
}

.panel-inner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 28px;
  right: 28px;
  height: 3px;
  background: linear-gradient(90deg, #e85a4f, #f093fb, #4facfe, #43e97b, #f7971e);
  border-radius: 0 0 4px 4px;
  opacity: 0.6;
}

.filter-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px 32px;
}

.filter-group.full-width {
  grid-column: 1 / -1;
}

.filter-label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: var(--sc-text-secondary);
  margin-bottom: 10px;
  letter-spacing: 0.02em;
}

/* 价格区间 */
.price-inputs {
  display: flex;
  align-items: center;
  gap: 8px;
}

.price-separator {
  color: var(--sc-text-muted);
  font-weight: 500;
  font-size: 14px;
}

/* 芯片行 */
.chip-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.chip-btn {
  padding: 6px 16px;
  border-radius: var(--sc-radius-full);
  font-size: 12.5px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
  border: 1.5px solid transparent;
  position: relative;
  overflow: hidden;
}

.chip-btn::before {
  content: '';
  position: absolute;
  inset: 0;
  opacity: 0;
  transition: opacity 0.25s ease;
}

.chip-btn:hover {
  transform: translateY(-2px) scale(1.03);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.chip-btn:hover::before {
  opacity: 0.08;
}

.chip-btn.active {
  transform: translateY(-1px) scale(1.02);
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.12);
  color: #fff;
  font-weight: 600;
}

/* 状态芯片 - 红色系 */
.chip-status {
  background: linear-gradient(135deg, #fff5f5 0%, #ffe8e8 100%);
  color: #dc2626;
  border-color: #fecaca;
}
.chip-status::before { background: #dc2626; }
.chip-status:hover {
  border-color: #ef4444;
  background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
}
.chip-status.active {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  border-color: #dc2626;
  box-shadow: 0 4px 14px rgba(220, 38, 38, 0.3);
}

/* 时间芯片 - 绿色系 */
.chip-time {
  background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
  color: #16a34a;
  border-color: #bbf7d0;
}
.chip-time::before { background: #16a34a; }
.chip-time:hover {
  border-color: #22c55e;
  background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
}
.chip-time.active {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border-color: #16a34a;
  box-shadow: 0 4px 14px rgba(22, 163, 74, 0.3);
}

/* 浏览量芯片 - 橙色系 */
.chip-view {
  background: linear-gradient(135deg, #fff7ed 0%, #ffedd5 100%);
  color: #ea580c;
  border-color: #fed7aa;
}
.chip-view::before { background: #ea580c; }
.chip-view:hover {
  border-color: #f97316;
  background: linear-gradient(135deg, #ffedd5 0%, #fed7aa 100%);
}
.chip-view.active {
  background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
  border-color: #ea580c;
  box-shadow: 0 4px 14px rgba(234, 88, 12, 0.3);
}

/* 收藏数芯片 - 紫色系 */
.chip-fav {
  background: linear-gradient(135deg, #faf5ff 0%, #f3e8ff 100%);
  color: #9333ea;
  border-color: #e9d5ff;
}
.chip-fav::before { background: #9333ea; }
.chip-fav:hover {
  border-color: #a855f7;
  background: linear-gradient(135deg, #f3e8ff 0%, #e9d5ff 100%);
}
.chip-fav.active {
  background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
  border-color: #9333ea;
  box-shadow: 0 4px 14px rgba(147, 51, 234, 0.3);
}

/* 成色滑块 */
.slider-wrap {
  padding: 4px 8px 0;
}

.slider-wrap :deep(.el-slider__runway) {
  height: 8px;
  border-radius: 4px;
  background: linear-gradient(90deg, #fef3c7 0%, #fde68a 30%, #a3e635 60%, #22c55e 100%);
}

.slider-wrap :deep(.el-slider__bar) {
  height: 8px;
  border-radius: 4px;
  background: linear-gradient(90deg, #f59e0b 0%, #84cc16 50%, #16a34a 100%);
}

.slider-wrap :deep(.el-slider__button-wrapper .el-slider__button) {
  width: 18px;
  height: 18px;
  border: 3px solid #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.18);
  transition: transform 0.2s ease;
}

.slider-wrap :deep(.el-slider__button-wrapper .el-slider__button:hover) {
  transform: scale(1.2);
}

.slider-wrap :deep(.el-slider__stop) {
  background: rgba(255, 255, 255, 0.6);
}

.slider-wrap :deep(.el-slider__marks-text) {
  font-size: 11px;
  color: var(--sc-text-muted);
  font-weight: 500;
}

/* 面板底部 */
.panel-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid var(--sc-border-light);
}

.apply-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 10px 28px;
  border-radius: var(--sc-radius-full);
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  border: none;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 4px 14px rgba(99, 102, 241, 0.3);
}

.apply-btn:hover {
  transform: translateY(-2px) scale(1.03);
  box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
}

.apply-btn:active {
  transform: translateY(0) scale(0.98);
}

/* 面板展开/收起动画 */
.panel-slide-enter-active {
  animation: panelSlideIn 0.4s cubic-bezier(0.22, 1, 0.36, 1) both;
}

.panel-slide-leave-active {
  animation: panelSlideOut 0.3s cubic-bezier(0.55, 0, 1, 0.45) both;
}

@keyframes panelSlideIn {
  from {
    opacity: 0;
    max-height: 0;
    transform: translateY(-16px) scale(0.96);
  }
  to {
    opacity: 1;
    max-height: 600px;
    transform: translateY(0) scale(1);
  }
}

@keyframes panelSlideOut {
  from {
    opacity: 1;
    max-height: 600px;
    transform: translateY(0) scale(1);
  }
  to {
    opacity: 0;
    max-height: 0;
    transform: translateY(-12px) scale(0.96);
  }
}

/* ====== 商品卡片网格 ====== */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
}

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

/* 商品状态标签（与后端一致：0=下架, 1=在售, 2=已售出, 3=审核中） */
.status-badge {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 4px 12px;
  font-size: 11px;
  font-weight: 600;
  border-radius: var(--sc-radius-full);
  letter-spacing: 0.03em;
  z-index: 2;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.status--on_sale { display: none; }

.status--off_shelf {
  background: linear-gradient(135deg, #94a3b8 0%, #64748b 100%);
  color: #fff;
}

.status--sold_out {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: #fff;
}

.status--reviewing {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  color: #fff;
}

.status--deleted {
  background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
  color: #fff;
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

/* ====== 响应式适配 ====== */
@media (max-width: 768px) {
  .filter-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }

  .filter-bar {
    flex-direction: column;
    gap: 12px;
    align-items: flex-start;
  }

  .filter-left {
    flex-wrap: wrap;
  }

  .filter-right {
    width: 100%;
    justify-content: space-between;
  }

  .panel-inner {
    padding: 18px 16px 16px;
  }

  .chip-row {
    gap: 6px;
  }

  .chip-btn {
    padding: 5px 12px;
    font-size: 12px;
  }
}
</style>