<template>
  <div class="page-container" v-loading="loading">
    <div v-if="goods" class="detail-grid">
      <!-- 左侧图片 -->
      <div class="detail-images">
        <el-image
          v-if="images.length > 0"
          :src="images[currentImageIndex]?.url"
          fit="contain"
          style="width:100%;height:400px;background:#f0f0f0;border-radius:12px"
        />
        <div v-else class="no-image">
          <el-icon :size="80"><PictureFilled /></el-icon>
          <p>暂无图片</p>
        </div>
        <div class="image-thumbs" v-if="images.length > 1">
          <div
            v-for="(img, i) in images"
            :key="i"
            class="thumb-item"
            :class="{ active: i === currentImageIndex }"
            @click="currentImageIndex = i"
          >
            <el-image :src="img.url" fit="cover" style="width:60px;height:60px;border-radius:6px" />
          </div>
        </div>
      </div>

      <!-- 右侧信息 -->
      <div class="detail-info">
        <h1 class="info-title">{{ goods.title }}</h1>
        <div class="info-price">¥{{ goods.price }}</div>
        <el-descriptions :column="2" border size="large">
          <el-descriptions-item label="成色">
            <el-rate v-model="conditionStars" disabled show-score text-color="#ff9900" />
          </el-descriptions-item>
          <el-descriptions-item label="交易方式">
            <el-tag :type="goods.tradeMethod === 'FACE' ? 'success' : 'warning'">
              {{ goods.tradeMethod === 'FACE' ? '面交' : goods.tradeMethod === 'LOCKER' ? '邮件柜' : '均可' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="校区">{{ goods.campusLocation || '未指定' }}</el-descriptions-item>
          <el-descriptions-item label="发布时间">{{ goods.createdAt?.substring(0, 10) }}</el-descriptions-item>
          <el-descriptions-item label="浏览量">
            <el-icon><View /></el-icon> {{ goods.viewCount }}
          </el-descriptions-item>
          <el-descriptions-item label="收藏数">
            <el-icon><Star /></el-icon> {{ goods.favoriteCount }}
          </el-descriptions-item>
        </el-descriptions>

        <div class="info-actions">
          <el-button
            :type="isFavorited ? 'warning' : 'default'"
            size="large"
            @click="handleFavorite"
            v-if="userStore.isLoggedIn"
          >
            <el-icon><Star /></el-icon>{{ isFavorited ? '已收藏' : '收藏' }}
          </el-button>
          <el-button type="primary" size="large" @click="handleContact" v-if="userStore.isLoggedIn">
            <el-icon><ChatDotRound /></el-icon>联系卖家
          </el-button>
          <el-button type="success" size="large" @click="showOrderDialog = true" v-if="userStore.isLoggedIn">
            <el-icon><ShoppingCart /></el-icon>立即购买
          </el-button>
        </div>

        <!-- 卖家信息 -->
        <el-card class="seller-card">
          <div class="seller-info">
            <el-avatar :size="48" :icon="UserFilled" />
            <div>
              <div class="seller-name">卖家 #{{ goods.sellerId }}</div>
              <div class="seller-credit">信用分: 80</div>
            </div>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 商品描述 -->
    <el-card v-if="goods" class="desc-card">
      <template #header><h2>商品详情</h2></template>
      <div class="desc-content">{{ goods.description || '卖家很懒，没有留下描述~' }}</div>
    </el-card>

    <!-- 下单对话框 -->
    <el-dialog v-model="showOrderDialog" title="确认下单" width="480px">
      <el-form label-width="80px">
        <el-form-item label="交易方式">
          <el-radio-group v-model="orderTradeMethod">
            <el-radio value="FACE">面交</el-radio>
            <el-radio value="LOCKER">邮件柜</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="面交地点" v-if="orderTradeMethod === 'FACE'">
          <el-input v-model="orderLocation" placeholder="如：图书馆门口" />
        </el-form-item>
        <el-form-item label="面交时间" v-if="orderTradeMethod === 'FACE'">
          <el-date-picker v-model="orderTime" type="datetime" placeholder="选择时间" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showOrderDialog = false">取消</el-button>
        <el-button type="primary" @click="handleCreateOrder" :loading="ordering">确认下单</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { UserFilled } from '@element-plus/icons-vue'
import { goodsApi, orderApi } from '@/api'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const goods = ref(null)
const images = ref([])
const isFavorited = ref(false)
const loading = ref(true)
const currentImageIndex = ref(0)

const showOrderDialog = ref(false)
const orderTradeMethod = ref('FACE')
const orderLocation = ref('')
const orderTime = ref(null)
const ordering = ref(false)

const conditionStars = computed(() => {
  if (!goods.value) return 0
  return Math.min(5, Math.ceil(goods.value.conditionLevel / 2))
})

async function load() {
  loading.value = true
  try {
    const res = await goodsApi.detail(route.params.uuid)
    goods.value = res.goods
    images.value = res.images || []
    isFavorited.value = res.isFavorited || false
  } finally {
    loading.value = false
  }
}

async function handleFavorite() {
  await goodsApi.toggleFavorite(goods.value.uuid)
  isFavorited.value = !isFavorited.value
  ElMessage.success(isFavorited.value ? '已收藏' : '已取消收藏')
}

function handleContact() {
  router.push(`/chat/${goods.value.sellerId}`)
}

async function handleCreateOrder() {
  ordering.value = true
  try {
    await orderApi.create({
      goodsUuid: goods.value.uuid,
      tradeMethod: orderTradeMethod.value,
      meetLocation: orderLocation.value,
      meetTime: orderTime.value?.toISOString(),
    })
    ElMessage.success('下单成功')
    showOrderDialog.value = false
    router.push('/orders')
  } finally {
    ordering.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  margin-bottom: 24px;
}
@media (max-width: 768px) {
  .detail-grid { grid-template-columns: 1fr; }
}
.no-image {
  width: 100%;
  height: 400px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #f0f0f0;
  border-radius: 12px;
  color: #c0c4cc;
}
.image-thumbs {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}
.thumb-item {
  cursor: pointer;
  border: 2px solid transparent;
  border-radius: 8px;
  overflow: hidden;
}
.thumb-item.active {
  border-color: #409EFF;
}
.info-title { font-size: 24px; margin-bottom: 12px; }
.info-price { font-size: 32px; color: #f56c6c; font-weight: bold; margin-bottom: 20px; }
.info-actions { margin-top: 20px; display: flex; gap: 12px; }
.seller-card { margin-top: 20px; }
.seller-info { display: flex; align-items: center; gap: 12px; }
.seller-name { font-weight: 600; }
.seller-credit { font-size: 13px; color: #909399; }
.desc-card { margin-bottom: 24px; }
.desc-content { white-space: pre-wrap; line-height: 1.8; min-height: 100px; }
</style>
