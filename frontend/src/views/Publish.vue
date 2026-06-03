<template>
  <div class="page-container">
    <el-card>
      <template #header>
        <h2>{{ isEdit ? '编辑商品' : '发布闲置' }}</h2>
      </template>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px" style="max-width:720px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入商品标题" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="分类" prop="categoryId">
          <el-select v-model="form.categoryId" placeholder="选择分类">
            <el-option v-for="cat in categories" :key="cat.id" :label="cat.name" :value="cat.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="form.price" :min="0" :precision="2" :step="1" placeholder="¥" style="width:200px" />
        </el-form-item>
        <el-form-item label="原价">
          <el-input-number v-model="form.originalPrice" :min="0" :precision="2" placeholder="选填" style="width:200px" />
        </el-form-item>
        <el-form-item label="成色" prop="conditionLevel">
          <el-slider v-model="form.conditionLevel" :min="1" :max="10" show-stops :marks="conditionMarks" style="width:300px" />
        </el-form-item>
        <el-form-item label="交易方式" prop="tradeMethod">
          <el-radio-group v-model="form.tradeMethod">
            <el-radio value="FACE">面交</el-radio>
            <el-radio value="LOCKER">邮件柜</el-radio>
            <el-radio value="BOTH">均可</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="校区">
          <el-input v-model="form.campusLocation" placeholder="如：校本部" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="5" placeholder="描述一下你的闲置物品..." maxlength="1000" show-word-limit />
        </el-form-item>
        <el-form-item label="图片">
          <el-upload
            v-model:file-list="fileList"
            :auto-upload="false"
            list-type="picture-card"
            :limit="9"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
          <template #extra><span class="tip">最多9张,支持jpg/png,单张不超过5MB</span></template>
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="form.isBargain" :true-value="1" :false-value="0">接受议价</el-checkbox>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" :loading="submitting" @click="handleSubmit">
            {{ isEdit ? '保存修改' : '发布商品' }}
          </el-button>
          <el-button size="large" @click="$router.back()">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
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
    } catch { /* ignore */ }
  }
})
</script>

<style scoped>
.tip { color: #909399; font-size: 13px; }
</style>
