<template>
  <div class="page-container">
    <el-card>
      <div class="profile-header">
        <el-avatar :size="80" :icon="UserFilled" :src="user?.avatarUrl" />
        <div class="profile-info">
          <h2>{{ user?.realName || user?.username }}</h2>
          <p>学号: {{ user?.studentId }}</p>
          <p>信用分: <span class="credit-score">{{ user?.creditScore || 80 }}</span></p>
        </div>
      </div>
    </el-card>

    <el-card style="margin-top:20px" v-if="isSelf">
      <template #header><h3>编辑资料</h3></template>
      <el-form label-width="80px" style="max-width:400px">
        <el-form-item label="手机号">
          <el-input v-model="editForm.phone" placeholder="手机号" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="editForm.email" placeholder="邮箱" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSave">保存</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { UserFilled } from '@element-plus/icons-vue'
import { userApi } from '@/api'
import { ElMessage } from 'element-plus'

const route = useRoute()
const user = ref(null)
const isSelf = ref(false)
const editForm = ref({ phone: '', email: '' })

onMounted(async () => {
  const currentUser = JSON.parse(localStorage.getItem('user') || '{}')
  const userId = route.params.id || currentUser.id
  isSelf.value = !route.params.id || Number(route.params.id) === currentUser.id

  try {
    const api = isSelf.value ? userApi.getMe : userApi.getProfile
    user.value = await api(userId)
    if (isSelf.value) {
      editForm.value = { phone: user.value.phone || '', email: user.value.email || '' }
    }
  } catch { /* ignore */ }
})

async function handleSave() {
  try {
    await userApi.updateProfile(editForm.value)
    ElMessage.success('保存成功')
  } catch { /* ignore */ }
}
</script>

<style scoped>
.profile-header {
  display: flex;
  align-items: center;
  gap: 24px;
}
.credit-score {
  color: #f56c6c;
  font-weight: bold;
  font-size: 18px;
}
</style>
