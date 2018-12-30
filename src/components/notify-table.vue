<template>
  <div class="container">
    <h2 id="request">租借请求</h2>
    <el-table :data="tableData" style="width: 100%">
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
  mounted: async function () {
    let rents = await this.$instance.getRentList()
    for (var i = 0; i < rents.length; i++) {
      let exist = await this.$instance.existRent(rents[i])
      if (exist) {
        let tmpRent = await this.$instance.rentPool(rents[i])
        if (tmpRent.state === 0) {
          let ownerAddress = await this.$instance.accountPool(tmpRent.id).ownerAddress
          if (ownerAddress === this.$user.$useraddr) {
            this.tableData.push({
              account: tmpRent.id,
              rentTime: tmpRent.rentTime,
              cost: tmpRent.cost,
              renter: tmpRent.renterAddress
            })
          }
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
      await this.$web3.eth.personal.unlockAccount(this.$user.$useraddr, this.$user.$password)
      await this.$instance.confirmRent(rows[index].account, { from: this.$user.$useraddr })
      rows.splice(index, 1)
    },
    async disagree (index, rows) {
      await this.$web3.eth.personal.unlockAccount(this.$user.$useraddr, this.$user.$password)
      await this.$instance.refuseRent(rows[index].account, { from: this.$user.$useraddr })
      rows.splice(index, 1)
    }
  }
}
</script>
