<template>
  <div>
    <topNav></topNav>
    <notifyTable></notifyTable>
  </div>
</template>

<script>
import topNav from '@/components/top-nav'
import notifyTable from '@/components/notify-table'

export default {
  name: 'notifyPage',
  components: {
    'topNav': topNav,
    'notifyTable': notifyTable
  }
}
</script>
