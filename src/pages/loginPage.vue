<template>
  <div>
    <loginForm></loginForm>
  </div>
</template>

<script>
import loginForm from '@/components/login-form'

export default {
  name: 'loginPage',
  components: {
    'loginForm': loginForm
  }
}
</script>
