<template>
  <div class="container">
    <h2>租借请求</h2>
    <el-table :data="tableData" stripe style="width: 100%">
      <el-table-column prop="account" label="账号" width="120px"></el-table-column>
      <el-table-column prop="rentTime" label="租借时长" width="150px"></el-table-column>
      <el-table-column prop="cost" label="金额" width="120px"></el-table-column>
      <el-table-column prop="renter" label="买家"></el-table-column>
      <el-table-column label="操作" width="100px">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="agree(scope.$index, tableData)">同意</el-button>
          <el-button type="text" size="small" @click="disagree(scope.$index, tableData)">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'notify',
  mounted: async () => {
    this.tableData = []
    let tmpRents = await this.$instance.waitingRent(this.$username)
    for (var i = 0; i < tmpRents.length; i++) {
      if (tmpRents.state === 0) {
        let owner = await this.$instance.accountPool(tmpRents[i].id)
        let ownerAddress = await this.$instance.userToAdderss(owner)
        if (ownerAddress === this.$useraddr) {
          this.tableData.append({
            account: tmpRents[i].id,
            rentTime: tmpRents[i].rentTime,
            cost: tmpRents[i].cost,
            renter: tmpRents[i].renterAddress
          })
        }
      }
    }
  },
  data () {
    return {
      tableData: []
    }
  },
  methods: {
    async agree (index, rows) {
      await this.$web3.eth.unlockAccount(this.$useraddr, this.$password)
      await this.$instance.confirmRent(rows[index].account, { from: this.$useraddr })
      rows.splice(index, 1)
    },
    async disagree (index, rows) {
      await this.$web3.eth.unlockAccount(this.$useraddr, this.$password)
      await this.$instance.refuseRent(rows[index].account, { from: this.$useraddr })
      rows.splice(index, 1)
    }
  }
}
</script>
