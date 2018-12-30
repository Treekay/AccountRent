<template>
  <div class="container">
    <h2>租用账号</h2>
    <el-table :data="tableData" style="width: 100%">
      <el-table-column prop="account" label="账号" width="120px"></el-table-column>
      <el-table-column prop="accountType" label="账号类型" width="150px"></el-table-column>
      <el-table-column prop="password" label="密码" width="120px"></el-table-column>
      <el-table-column prop="startTime" label="开始时间" width="180px"></el-table-column>
      <el-table-column prop="endTime" label="到期时间" width="180px"></el-table-column>
      <el-table-column prop="description" label="账号描述"></el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'rentTable',
  mounted: async function () {
    let rents = await this.$instance.getRentList()
    for (var i = 0; i < rents.length; i++) {
      let exist = await this.$instance.existRent(rents[i])
      if (exist) {
        let tmpRent = await this.$instance.rentPool(rents[i])
        if (tmpRent.renterAddress === this.$useraddr && rents.state === 1) {
          let tmpAccount = await this.$instance.accountPool(tmpRent.id)
          this.tableData.push({
            account: tmpAccount.id,
            accountType: tmpAccount.accountType,
            password: tmpAccount.password,
            startTime: tmpRent.beginTime,
            endTime: tmpRent.endTime,
            description: tmpAccount.description
          })
        }
      }
    }
  },
  data () {
    return {
      tableData: []
    }
  }
}
</script>
