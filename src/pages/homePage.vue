<template>
  <div>
    <topNav></topNav>
    <saleList></saleList>
    <buyForm></buyForm>
  </div>
</template>

<script>
import topNav from '@/components/top-nav'
import saleList from '@/components/sale-list'
import buyForm from '@/components/buy-form'

export default {
  name: 'homePage',
  components: {
    'topNav': topNav,
    'saleList': saleList,
    'buyForm': buyForm
  }
}
</script>
