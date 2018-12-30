<template>
  <div>
    <topNav></topNav>
    <historyTable></historyTable>
  </div>
</template>

<script>
import topNav from '@/components/top-nav'
import historyTable from '@/components/history-table'

export default {
  name: 'historyPage',
  components: {
    'topNav': topNav,
    'historyTable': historyTable
  }
}
</script>
