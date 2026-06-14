<template>
  <div class="publish-page">
    <!-- 页面标题区 -->
    <div class="page-header">
      <h1 class="page-title">{{ isEdit ? '编辑商品' : '发布闲置' }}</h1>
      <p class="page-subtitle">{{ isEdit ? '修改商品信息后保存' : '填写以下信息，让你的闲置物品找到新主人' }}</p>
    </div>

    <!-- 表单主体 -->
    <div class="form-body">
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top" class="publish-form">

        <!-- 基础信息组 -->
        <el-card class="form-section-card" shadow="hover">
          <template #header>
            <div class="section-header">
              <span class="section-icon">📋</span>
              <h2 class="section-title">基础信息</h2>
            </div>
          </template>
          <div class="section-grid">
            <el-form-item label="商品标题" prop="title" class="full-width">
              <el-input v-model="form.title" placeholder="请输入商品标题（最多50字）" maxlength="50" show-word-limit size="large" />
            </el-form-item>
            <el-form-item label="商品分类" prop="categoryId">
              <el-select v-model="form.categoryId" placeholder="选择分类" size="large" style="width:100%">
                <el-option v-for="cat in categories" :key="cat.id" :label="cat.name" :value="cat.id" />
              </el-select>
            </el-form-item>
            <el-form-item label="售价 (¥)" prop="price">
              <el-input-number v-model="form.price" :min="0" :precision="2" :step="1" placeholder="¥" size="large" style="width:100%" />
            </el-form-item>
            <el-form-item label="原价 (¥)">
              <el-input-number v-model="form.originalPrice" :min="0" :precision="2" placeholder="选填" size="large" style="width:100%" />
            </el-form-item>
          </div>
        </el-card>

        <!-- 商品详情组 -->
        <el-card class="form-section-card" shadow="hover">
          <template #header>
            <div class="section-header">
              <span class="section-icon">📦</span>
              <h2 class="section-title">商品详情</h2>
            </div>
          </template>

          <el-form-item label="成色" prop="conditionLevel">
            <div class="slider-wrapper">
              <div class="slider-header">
                <span class="current-value">当前成色: {{ form.conditionLevel }}/10</span>
              </div>
              <el-slider v-model="form.conditionLevel" :min="1" :max="10" show-stops size="large" />
              <div class="condition-labels">
                <span data-pos="0">废品</span>
                <span data-pos="25">可用</span>
                <span data-pos="50">良好</span>
                <span data-pos="75">较新</span>
                <span data-pos="100">全新</span>
              </div>
            </div>
          </el-form-item>

          <el-form-item label="交易方式" prop="tradeMethod">
            <el-radio-group v-model="form.tradeMethod" size="large">
              <el-radio-button value="FACE">面交</el-radio-button>
              <el-radio-button value="LOCKER">邮件柜</el-radio-button>
              <el-radio-button value="BOTH">均可</el-radio-button>
            </el-radio-group>
          </el-form-item>

          <el-form-item label="校区位置">
            <el-input v-model="form.campusLocation" placeholder="如：校本部、南校区" size="large" />
          </el-form-item>

          <el-form-item label="商品描述" prop="description">
            <el-input v-model="form.description" type="textarea" :rows="5" placeholder="描述一下你的闲置物品..." maxlength="1000" show-word-limit resize="vertical" />
          </el-form-item>
        </el-card>

        <!-- 图片上传区 -->
        <el-card class="form-section-card upload-card" shadow="hover">
          <template #header>
            <div class="section-header">
              <span class="section-icon">🖼️</span>
              <h2 class="section-title">商品图片</h2>
            </div>
          </template>

          <div class="upload-area-wrapper">
            <el-upload
              v-model:file-list="fileList"
              :auto-upload="false"
              list-type="picture-card"
              :limit="9"
              accept="image/*"
              class="custom-upload"
            >
              <div class="upload-trigger">
                <el-icon :size="32"><Plus /></el-icon>
                <p>点击或拖拽上传图片</p>
                <span class="upload-tip">支持 jpg/png 格式，单张不超过 5MB</span>
              </div>
            </el-upload>
          </div>
          <p class="extra-tip">最多上传 9 张图片，建议第一张为商品正面图</p>
        </el-card>

        <!-- 其他选项 -->
        <el-form-item style="margin-top:8px;">
          <el-checkbox v-model="form.isBargain" :true-value="1" :false-value="0" size="large">接受议价</el-checkbox>
        </el-form-item>

        <!-- 提交按钮 -->
        <div class="submit-area">
          <el-button type="primary" size="large" class="submit-btn" :loading="submitting" @click="handleSubmit">
            {{ isEdit ? '保存修改' : '立即发布' }}
          </el-button>
          <el-button size="large" class="cancel-btn" @click="$router.back()">取消</el-button>
        </div>

      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { goodsApi, categoryApi } from '@/api'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()

const isEdit = ref(!!route.params.uuid)
const submitting = ref(false)
const categories = ref([])
const fileList = ref([])

const conditionMarks = {
  1: '废品', 3: '可用', 5: '良好', 7: '较新', 10: '全新'
}

const form = ref({
  title: '',
  categoryId: null,
  price: null,
  originalPrice: null,
  conditionLevel: 7,
  tradeMethod: 'FACE',
  campusLocation: '',
  description: '',
  isBargain: 0,
})

const rules = {
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  categoryId: [{ required: true, message: '请选择分类', trigger: 'change' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
  conditionLevel: [{ required: true, message: '请选择成色', trigger: 'change' }],
}

async function handleSubmit() {
  submitting.value = true
  try {
    const formData = new FormData()
    const data = { ...form.value }
    formData.append('data', new Blob([JSON.stringify(data)], { type: 'application/json' }))
    fileList.value.forEach((f) => {
      formData.append('images', f.raw)
    })

    if (isEdit.value) {
      await goodsApi.update(route.params.uuid, formData)
      ElMessage.success('修改成功')
    } else {
      await goodsApi.publish(formData)
      ElMessage.success('发布成功')
    }
    router.push('/my-goods')
  } catch {
    // 错误已在拦截器处理
  } finally {
    submitting.value = false
  }
}

onMounted(async () => {
  try {
    const res = await categoryApi.list()
    categories.value = res || []
  } catch { /* ignore */ }

  // 编辑模式加载已有数据
    if (isEdit.value) {
      try {
        const res = await goodsApi.detail(route.params.uuid)
        Object.assign(form.value, {
          categoryId: res.goods.categoryId,
          title: res.goods.title,
          price: res.goods.price,
          originalPrice: res.goods.originalPrice,
          conditionLevel: res.goods.conditionLevel,
          tradeMethod: res.goods.tradeMethod,
          campusLocation: res.goods.campusLocation || '',
          description: res.goods.description || '',
          isBargain: res.goods.isBargain,
        })
        
        // 加载已有的商品图片
        if (res.images && res.images.length > 0) {
          fileList.value = res.images.map((img, index) => ({
            uid: `img-${index}`,
            name: `image-${index + 1}.jpg`,
            url: img.url,
            status: 'success',
          }))
        }
      } catch { /* ignore */ }
    }
})
</script>

<style scoped>
.publish-page {
  max-width: 800px;
  margin: 0 auto;
  padding: 28px 24px 60px;
}

/* ===== 页面标题区 ===== */
.page-header {
  text-align: center;
  margin-bottom: 36px;
}

.page-title {
  font-size: 32px;
  font-weight: 800;
  color: var(--sc-text);
  margin: 0 0 8px 0;
  letter-spacing: -0.5px;
}

.page-subtitle {
  color: var(--sc-text-secondary);
  font-size: 15px;
  margin: 0;
}

/* ===== 表单主体 ===== */
.form-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.publish-form :deep(.el-form-item__label) {
  font-weight: 600;
  color: var(--sc-text);
  padding-bottom: 6px;
}

/* ===== 分组卡片 ===== */
.form-section-card {
  border-radius: var(--sc-radius-lg);
  border: none;
  overflow: hidden;
  transition: box-shadow 0.3s ease;
}

.form-section-card:hover {
  box-shadow: var(--sc-shadow-lg);
}

.form-section-card :deep(.el-card__header) {
  background: linear-gradient(135deg, #fefefe, #f8f6f3);
  padding: 18px 24px;
  border-bottom: 1px solid #f0ede8;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 10px;
}

.section-icon {
  font-size: 20px;
}

.section-title {
  font-size: 17px;
  font-weight: 700;
  color: var(--sc-text);
  margin: 0;
}

/* 基础信息网格 */
.section-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px 20px;
  padding: 4px 0;
}

.section-grid .full-width {
  grid-column: 1 / -1;
}

@media (max-width: 600px) {
  .section-grid {
    grid-template-columns: 1fr;
  }
}

/* 滑块区域 */
.slider-wrapper {
  padding: 8px 0 16px;
  width: 50%;
}
.slider-wrapper :deep(.el-slider) {
  height: auto;
  margin: 10px 0;
}
.slider-wrapper :deep(.el-slider__runway) {
  margin: 0;
}

/* 当前成色值 - 滑块上方 */
.slider-header {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 0;
}
.current-value {
  color: var(--sc-primary);
  font-weight: 700;
  font-size: 14px;
}

/* 成色标签行 - 滑块下方，对齐到对应刻度位置 */
.condition-labels {
  display: block;
  position: relative;
  height: 28px;
  margin-top: -4px;
  font-size: 12px;
  color: var(--sc-text-muted);
}
.condition-labels span {
  position: absolute;
  transform: translateX(-50%);
  white-space: nowrap;
}
.condition-labels span[data-pos="0"]   { left: 0%; }
.condition-labels span[data-pos="25"]  { left: 25%; }
.condition-labels span[data-pos="50"]  { left: 50%; }
.condition-labels span[data-pos="75"]  { left: 75%; }
.condition-labels span[data-pos="100"] { left: 100%; }

/* ===== 图片上传区 ===== */
.upload-card :deep(.el-card__header) {
  background: linear-gradient(135deg, #fff9f5, #fff5ee);
}

.upload-area-wrapper {
  padding: 12px 0;
}

.custom-upload :deep(.el-upload--picture-card) {
  width: 140px;
  height: 140px;
  border-radius: 14px;
  border: 2px dashed var(--sc-primary);
  background: rgba(232, 90, 79, 0.03);
  transition: all 0.25s ease;
}

.custom-upload :deep(.el-upload--picture-card:hover) {
  border-color: var(--sc-primary-dark);
  background: rgba(232, 90, 79, 0.08);
  transform: scale(1.02);
}

.upload-trigger {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 6px;
  height: 100%;
  color: var(--sc-text-secondary);
}

.upload-trigger p {
  margin: 0;
  font-size: 13px;
  font-weight: 500;
}

.upload-tip {
  font-size: 11px;
  color: #c0c4cc;
}

.extra-tip {
  text-align: center;
  color: var(--sc-text-secondary);
  font-size: 13px;
  margin: 10px 0 0 0;
}

/* ===== 提交按钮区 ===== */
.submit-area {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 16px;
  padding: 20px 0;
}

.submit-btn {
  width: 220px !important;
  height: 50px !important;
  font-size: 17px !important;
  font-weight: 700 !important;
  border-radius: 14px !important;
  background: var(--sc-primary) !important;
  border-color: var(--sc-primary) !important;
  transition: all 0.25s ease !important;
}

.submit-btn:hover {
  background: var(--sc-primary-dark) !important;
  border-color: var(--sc-primary-dark) !important;
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(232, 90, 79, 0.35) !important;
}

.cancel-btn {
  width: 120px !important;
  height: 50px !important;
  font-size: 15px !important;
  font-weight: 600 !important;
  border-radius: 14px !important;
}
</style>
