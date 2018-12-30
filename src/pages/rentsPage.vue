<template>
  <div>
    <topNav></topNav>
    <rentTable></rentTable>
  </div>
</template>

<script>
import topNav from '@/components/top-nav'
import rentTable from '@/components/rent-table'

export default {
  name: 'rentsPage',
  components: {
    'topNav': topNav,
    'rentTable': rentTable
  }
}
</script>
