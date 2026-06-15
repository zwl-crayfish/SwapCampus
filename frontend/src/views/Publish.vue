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
              <div class="title-input-row">
                <el-input v-model="form.title" placeholder="请输入商品标题（最多50字）" maxlength="50" show-word-limit size="large" @blur="onTitleBlur" />
                <button class="ai-trigger-btn" :class="{ loading: aiAnalyzing }" title="AI 智能分析" @click="triggerAISuggest">✨</button>
              </div>
            </el-form-item>

            <!-- AI 智能助手面板 -->
            <div class="ai-assist-panel" :class="{ analyzing: aiAnalyzing }" v-if="aiSuggestions.length > 0 || pricingSuggestion || aiAnalyzing">
              <!-- 分类建议 -->
              <div class="ai-section ai-category-suggest" v-if="aiSuggestions.length > 0">
                <div class="ai-label">✨ AI 推荐分类</div>
                <div class="ai-chips">
                  <span v-for="(cat, i) in aiSuggestions" :key="i"
                        class="ai-chip" :class="{ active: form.categoryId === cat.id }"
                        @click="form.categoryId = cat.id">
                    {{ cat.name }}
                  </span>
                </div>
              </div>

              <!-- 定价建议 -->
              <div class="ai-section ai-price-suggest" v-if="pricingSuggestion">
                <div class="ai-label">
                  💡 定价建议
                  <span class="ai-source-tag" :class="aiSource === 'LLM' ? 'source-llm' : 'source-local'">
                    {{ aiSource === 'LLM' ? '🤖 大模型' : '📋 本地规则' }}
                  </span>
                </div>
                <div class="price-suggest-bar">
                  <span class="suggest-range">¥{{ pricingSuggestion.min ?? '--' }} ~ ¥{{ pricingSuggestion.max ?? '--' }}</span>
                  <span class="suggest-avg">均 ¥{{ pricingSuggestion.avg ?? '--' }}</span>
                  <button type="button" class="adopt-btn" @click="adoptPrice" :disabled="!pricingSuggestion.avg">采纳</button>
                </div>
                <div class="price-hint">
                  基于「{{ (conditionMarks[form.conditionLevel] || {}).label || '较新' }}」成色
                  <template v-if="form.originalPrice"> + 原价 ¥{{ form.originalPrice }}</template>
                  综合估算
                </div>
                <div class="ai-reasoning" v-if="aiReasoning">
                  📝 {{ aiReasoning }}
                </div>
              </div>
            </div>

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
                <template v-for="(info, level) in conditionMarks" :key="level">
                  <span :style="{ left: ((level - 1) / 9 * 100) + '%' }">{{ info.label }}</span>
                </template>
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
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { goodsApi, categoryApi, aiApi } from '@/api'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()

const isEdit = ref(!!route.params.uuid)
const submitting = ref(false)
const categories = ref([])
const fileList = ref([])

// ===== AI 智能分类与定价建议 =====
const aiSuggestions = ref([])
const pricingSuggestion = ref(null)
const aiAnalyzing = ref(false)
const aiSource = ref('')        // 'LLM' 或 'LOCAL_FALLBACK'
const aiReasoning = ref('')     // AI 的推理说明

// 关键词到分类名称的映射（用于模糊匹配）
const keywordCategoryMap = [
  { keywords: ['书', '教材', '课本', '考研', '英语', '数学', '计算机', '编程', '小说', '文学', '漫画'], basePrice: [5, 200], categoryHints: ['书籍', '教材', '图书', '教辅'] },
  { keywords: ['手机', '电脑', '笔记本', '平板', '耳机', '键盘', '鼠标', '显示器', '相机', 'iPad', '数码'], basePrice: [50, 5000], categoryHints: ['数码', '电子', '手机', '电脑'] },
  { keywords: ['衣服', '鞋', '裙', '裤', '外套', '卫衣', '包包', '帽子', '配饰', '穿搭'], basePrice: [10, 800], categoryHints: ['服饰', '服装', '鞋包', '衣'] },
  { keywords: ['自行车', '滑板', '哑铃', '瑜伽', '篮球', '足球', '球拍', '健身', '运动'], basePrice: [20, 1500], categoryHints: ['运动', '健身', '体育'] },
  { keywords: ['台灯', '椅子', '收纳', '床', '沙发', '桌子', '窗帘', '地毯', '装饰', '摆件', '家居'], basePrice: [15, 600], categoryHints: ['家居', '生活', '日用'] },
  { keywords: ['化妆品', '口红', '护肤', '面膜', '香水', '洗护', '美妆', '防晒'], basePrice: [10, 500], categoryHints: ['美妆', '护肤', '彩妆'] },
]

const conditionMarks = {
  1: { label: '废品', factor: 0.15 },
  2: { label: '较差', factor: 0.3 },
  3: { label: '可用', factor: 0.45 },
  4: { label: '一般', factor: 0.55 },
  5: { label: '良好', factor: 0.65 },
  6: { label: '不错', factor: 0.75 },
  7: { label: '较新', factor: 0.85 },
  8: { label: '很新', factor: 0.92 },
  9: { label: '近全新', factor: 0.97 },
  10: { label: '全新', factor: 1.0 },
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
      ElMessage.success('发布成功！商品正在等待管理员审核，通过后将自动上架')
    }
    router.push('/my-goods')
  } catch {
    // 错误已在拦截器处理
  } finally {
    submitting.value = false
  }
}

// ===== AI 智能分析函数 =====

/** 根据标题关键词匹配最相关的分类 */
function matchCategoriesByTitle(title) {
  const matched = []
  for (const mapItem of keywordCategoryMap) {
    const hit = mapItem.keywords.some(kw => title.includes(kw))
    if (hit) {
      // 在 categories 中模糊匹配相关分类
      const relatedCats = categories.value.filter(cat =>
        mapItem.categoryHints.some(hint => cat.name.includes(hint))
      )
      matched.push(...relatedCats)
    }
  }
  // 去重，取前3个
  const unique = []
  const seen = new Set()
  for (const cat of matched) {
    if (!seen.has(cat.id)) {
      seen.add(cat.id)
      unique.push(cat)
      if (unique.length >= 3) break
    }
  }
  return unique
}

/** 根据匹配结果、成色等级、原价生成合理的价格建议 */
function generatePriceSuggestion(title, matchedCategories) {
  // ① 找到命中的分类，取其预设价格区间
  let baseMin = 10
  let baseMax = 500
  for (const mapItem of keywordCategoryMap) {
    if (mapItem.keywords.some(kw => title.includes(kw))) {
      baseMin = mapItem.basePrice[0]
      baseMax = mapItem.basePrice[1]
      break
    }
  }

  // ② 计算基准价：分类中值
  const categoryMid = (baseMin + baseMax) / 2

  // ③ 成色系数：成色越低，建议售价越低（废品15% → 全新100%）
  const condLevel = form.value.conditionLevel || 7
  const condFactor = (conditionMarks[condLevel] || { factor: 0.85 }).factor

  // ④ 如果用户填了原价，以原价为基准；否则以分类中值为基准
  let basePrice = form.value.originalPrice || categoryMid

  // 原价不应低于分类最低价，也不应高于分类最高价的1.5倍（防止原价填错）
  basePrice = Math.max(baseMin, Math.min(basePrice, baseMax * 1.5))

  // ⑤ 成色折算后的合理售价
  let suggestedPrice = basePrice * condFactor

  // ⑥ 小幅度随机波动（±12%，让建议看起来自然但不离谱）
  const randomFactor = 0.88 + Math.random() * 0.24   // 0.88 ~ 1.12
  suggestedPrice = Math.round(suggestedPrice * randomFactor)

  // ⑦ 确保价格在合理范围内：不低于分类最低价的30%，不超过原价或分类最高价
  const minPrice = Math.max(Math.round(baseMin * 0.3), Math.round(suggestedPrice * 0.65))
  const maxPrice = Math.min(
    Math.round(form.value.originalPrice || baseMax),
    Math.round(suggestedPrice * 1.4),
    Math.round(baseMax * 1.2)
  )
  const avg = Math.round((minPrice + maxPrice) / 2)

  // ⑧ 保证 min ≤ avg ≤ max 且均为正数
  return {
    min: Math.max(1, Math.min(minPrice, avg)),
    max: Math.max(minPrice, maxPrice),
    avg: Math.max(1, avg),
  }
}

/** 触发AI智能分析（优先调用LLM大模型，失败时降级为本地规则引擎） */
async function triggerAISuggest() {
  const title = form.value.title?.trim()
  if (!title) {
    ElMessage.warning('请先输入商品标题')
    return
  }
  aiAnalyzing.value = true
  aiSuggestions.value = []
  pricingSuggestion.value = null
  aiSource.value = ''
  aiReasoning.value = ''

  try {
    // ★ 优先尝试调用后端 LLM 接口（智谱 GLM-4-Flash）
    const llmResult = await aiApi.suggest({
      title: title,
      originalPrice: form.value.originalPrice,
      conditionLevel: form.value.conditionLevel,
    })

    // LLM 返回成功 — 使用大模型结果
    if (llmResult && llmResult.suggestedCategories) {
      // 将 LLM 返回的分类名匹配到后端分类列表
      const matchedCats = []
      for (const catName of llmResult.suggestedCategories) {
        const found = categories.value.find(c =>
          c.name.includes(catName) || catName.includes(c.name)
        )
        if (found && !matchedCats.some(c => c.id === found.id)) {
          matchedCats.push(found)
        }
      }
      aiSuggestions.value = matchedCats.length > 0 ? matchedCats : categories.value.slice(0, 3)

      // LLM 价格区间
      if (llmResult.priceRange) {
        pricingSuggestion.value = {
          min: llmResult.priceRange.min,
          max: llmResult.priceRange.max,
          avg: llmResult.priceRange.suggested,
        }
      }

      aiSource.value = llmResult.source || 'LLM'
      aiReasoning.value = llmResult.reasoning || ''
      ElMessage.success('AI 智能分析完成（基于大模型）')
      return
    }

    // LLM 返回了但数据不完整 → 走降级
    throw new Error('LLM 返回数据不完整')

  } catch (e) {
    // ★ LLM 调用失败 → 降级为本地规则引擎
    console.warn('AI 大模型不可用，降级为本地规则:', e?.message || e)

    try {
      // a. 根据标题关键词匹配分类
      const matched = matchCategoriesByTitle(title)
      aiSuggestions.value = matched.length > 0 ? matched : categories.value.slice(0, 3)

      // b. 用本地算法生成价格建议（考虑成色+原价）
      pricingSuggestion.value = generatePriceSuggestion(title, aiSuggestions.value)

      aiSource.value = 'LOCAL_FALLBACK'
      aiReasoning.value = '当前 AI 服务暂不可用，已使用本地规则引擎生成建议'
      ElMessage.warning('AI 服务暂时不可用，已切换为本地建议')

    } catch (localErr) {
      console.error('本地规则引擎也失败了:', localErr)
      ElMessage.error('AI 分析失败，请手动填写')
    }
  } finally {
    aiAnalyzing.value = false
  }
}

/** 标题失焦时自动触发AI分析（标题超过2个字） */
function onTitleBlur() {
  const title = form.value.title?.trim()
  if (title && title.length >= 2 && aiSuggestions.value.length === 0) {
    triggerAISuggest()
  }
}

/** 采纳定价建议 */
function adoptPrice() {
  if (!pricingSuggestion.value) return
  form.value.price = pricingSuggestion.value.avg
  ElMessage.success('已采纳AI定价建议')
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
  font-size: 11px;
  color: var(--sc-text-muted);
}
.condition-labels span {
  position: absolute;
  transform: translateX(-50%);
  white-space: nowrap;
}

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

/* ===== AI 智能助手面板 ===== */
.title-input-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.title-input-row .el-input {
  flex: 1;
}

/* AI 触发按钮 - 圆形紫色渐变 */
.ai-trigger-btn {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  border: none;
  background: linear-gradient(135deg, #9b59b6, #8e44ad);
  color: #fff;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all 0.35s ease;
  box-shadow: 0 2px 8px rgba(155, 89, 182, 0.35);
}

.ai-trigger-btn:hover {
  transform: rotate(180deg) scale(1.1);
  box-shadow: 0 4px 16px rgba(155, 89, 182, 0.55), 0 0 24px rgba(155, 89, 182, 0.25);
}

.ai-trigger-btn:active {
  transform: rotate(180deg) scale(0.95);
}

/* AI 分析中的 loading 状态 */
.ai-trigger-btn.loading {
  pointer-events: none;
  background: linear-gradient(135deg, #bdc3c7, #95a5a6);
}

.ai-trigger-btn.loading::after {
  content: '';
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: ai-spin 0.7s linear infinite;
}

@keyframes ai-spin {
  to { transform: rotate(360deg); }
}

/* AI 助手面板整体 */
.ai-assist-panel {
  margin-top: 12px;
  padding: 18px 20px;
  background: linear-gradient(135deg, #f8f5ff, #f3effa);
  border-radius: var(--sc-radius-lg);
  border-left: 4px solid #9b59b6;
  position: relative;
  overflow: hidden;
}

/* 微妙的点阵图案背景 */
.ai-assist-panel::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: radial-gradient(circle, rgba(155, 89, 182, 0.06) 1px, transparent 1px);
  background-size: 16px 16px;
  pointer-events: none;
}

/* shimmer 骚屏动效（分析中） */
.ai-assist-panel.analyzing::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  animation: ai-shimmer 1.2s ease-in-out infinite;
  pointer-events: none;
}

@keyframes ai-shimmer {
  0% { left: -100%; }
  100% { left: 100%; }
}

/* 每个 AI 分区 */
.ai-section {
  position: relative;
  z-index: 1;
  padding-bottom: 14px;
  margin-bottom: 14px;
  border-bottom: 1px dashed rgba(155, 89, 182, 0.2);
}

.ai-section:last-child {
  padding-bottom: 0;
  margin-bottom: 0;
  border-bottom: none;
}

/* AI 标签文字 */
.ai-label {
  font-size: 13px;
  font-weight: 700;
  color: #8e44ad;
  margin-bottom: 10px;
  letter-spacing: 0.3px;
}

/* 分类芯片容器 */
.ai-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

/* 分类芯片 */
.ai-chip {
  display: inline-block;
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
  color: var(--sc-text-secondary);
  background: #fff;
  border: 1.5px solid #dcdfe6;
  cursor: pointer;
  transition: all 0.25s ease;
  user-select: none;
}

.ai-chip:hover {
  border-color: #9b59b6;
  color: #8e44ad;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(155, 89, 182, 0.15);
}

.ai-chip.active {
  background: linear-gradient(135deg, #9b59b6, #8e44ad);
  color: #fff;
  border-color: transparent;
  box-shadow: 0 3px 12px rgba(142, 68, 173, 0.3);
}

/* 价格建议行 */
.price-suggest-bar {
  display: flex;
  align-items: center;
  gap: 14px;
  flex-wrap: wrap;
}

/* 价格区间 - 渐变文字 */
.suggest-range {
  font-size: 20px;
  font-weight: 800;
  background: linear-gradient(135deg, #9b59b6, #3498db);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 0.5px;
}

/* 均价显示 */
.suggest-avg {
  font-size: 13px;
  color: #909399;
  font-weight: 600;
}

/* 采纳按钮 */
.adopt-btn {
  margin-left: auto;
  padding: 7px 22px;
  border: none;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  color: #fff;
  background: linear-gradient(135deg, #9b59b6, #4a69bd);
  cursor: pointer;
  transition: all 0.28s ease;
  box-shadow: 0 3px 10px rgba(74, 105, 189, 0.25);
}

.adopt-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(74, 105, 189, 0.38);
}

.adopt-btn:active {
  transform: translateY(0) scale(0.96);
}

/* 定价建议提示文字 */
.price-hint {
  margin-top: 8px;
  font-size: 12px;
  color: #909399;
  text-align: center;
  line-height: 1.5;
}

/* AI 数据来源标签 */
.ai-source-tag {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 10px;
  margin-left: 8px;
  vertical-align: middle;
  font-weight: normal;
}
.source-llm {
  background: #e8f5e9;
  color: #2e7d32;
  border: 1px solid #a5d6a7;
}
.source-local {
  background: #fff3e0;
  color: #e65100;
  border: 1px solid #ffcc80;
}

/* AI 推理说明 */
.ai-reasoning {
  margin-top: 6px;
  padding: 6px 12px;
  background: #f5f7fa;
  border-radius: 6px;
  font-size: 12px;
  color: #606266;
  line-height: 1.5;
  text-align: left;
}
</style>
