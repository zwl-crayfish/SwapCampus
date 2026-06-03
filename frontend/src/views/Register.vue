<template>
  <div class="auth-page">
    <div class="auth-card">
      <h1 class="auth-title">
        <el-icon :size="32"><ShoppingBag /></el-icon>
        SwapCampus 注册
      </h1>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="0" size="large">
        <el-form-item prop="studentId">
          <el-input v-model="form.studentId" placeholder="学号" prefix-icon="Postcard" />
        </el-form-item>
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="用户名" prefix-icon="User" />
        </el-form-item>
        <el-form-item prop="realName">
          <el-input v-model="form.realName" placeholder="真实姓名" prefix-icon="UserFilled" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="密码（至少6位）" prefix-icon="Lock" show-password />
        </el-form-item>
        <el-form-item prop="phone">
          <el-input v-model="form.phone" placeholder="手机号（选填）" prefix-icon="Phone" />
        </el-form-item>
        <el-form-item prop="email">
          <el-input v-model="form.email" placeholder="邮箱（选填）" prefix-icon="Message" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" style="width:100%" @click="handleRegister">
            注册
          </el-button>
        </el-form-item>
      </el-form>
      <div class="auth-link">
        已有账号？<router-link to="/login">立即登录</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const loading = ref(false)

const form = ref({
  studentId: '',
  username: '',
  realName: '',
  password: '',
  phone: '',
  email: '',
})

const rules = {
  studentId: [{ required: true, message: '请输入学号', trigger: 'blur' }],
  username: [{ required: true, min: 3, max: 20, message: '用户名3-20位', trigger: 'blur' }],
  realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  password: [{ required: true, min: 6, max: 30, message: '密码6-30位', trigger: 'blur' }],
}

async function handleRegister() {
  loading.value = true
  try {
    await userStore.register(form.value)
    ElMessage.success('注册成功')
    router.push('/')
  } catch {
    // 错误已在拦截器处理
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.auth-card {
  background: #fff;
  border-radius: 16px;
  padding: 40px;
  width: 420px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.15);
}
.auth-title {
  text-align: center;
  font-size: 24px;
  margin-bottom: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #409EFF;
}
.auth-link {
  text-align: center;
  color: #909399;
  font-size: 14px;
}
</style>
