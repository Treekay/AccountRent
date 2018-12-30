<template>
  <div>
    <topNav></topNav>
    <myAccounts></myAccounts>
    <createForm></createForm>
  </div>
</template>

<script>
import topNav from '@/components/top-nav'
import myAccounts from '@/components/my-accounts'
import createForm from '@/components/create-form'

export default {
  name: 'minePage',
  components: {
    'topNav': topNav,
    'myAccounts': myAccounts,
    'createForm': createForm
  }
}
</script>
