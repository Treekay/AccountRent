<template>
  <div class="container">
    <h2>交易记录</h2>
    <el-table :data="tableData" stripe style="width: 100%">
      <el-table-column prop="account" label="账号" width="120px"></el-table-column>
      <el-table-column prop="rentType" label="交易类型" width="150px"></el-table-column>
      <el-table-column prop="startTime" label="开始时间" width="180px"></el-table-column>
      <el-table-column prop="endTime" label="到期时间" width="180px"></el-table-column>
      <el-table-column prop="cost" label="总金额"></el-table-column>
      <el-table-column prop="rentState" label="交易状态" width="100px"></el-table-column>
      <el-table-column label="操作" width="100px">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click='finishRent(scope.$index, tableData)'>结束</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'history',
  mounted: async () => {
    this.tableData = []
    let allRents = await this.$instance.getRents()
    for (var i = 0; i < allRents.length; i++) {
      let tmpAccount = await this.$instance.getAccount(allRents[i].id)
      if (allRents[i].state === 1) {
        if (allRents[i].renterAddress === this.$useraddr || tmpAccount.ownerAddress === this.$useraddr) {
          let tmpRentType
          if (tmpAccount.ownerAddress === this.$useraddr) {
            tmpRentType = '借出'
          } else {
            tmpRentType = '借入'
          }
          let tmpRentState
          if ((new Date()).valueOf() >= allRents[i].endTime) {
            tmpRentState = '已到期'
          } else {
            tmpRentState = '使用中'
          }
          this.tableData.append({
            account: tmpAccount.id,
            rentType: tmpRentType,
            startTime: allRents[i].beginTime,
            endTime: allRents[i].endTime,
            accountType: tmpAccount.accountType,
            cost: allRents[i].cost,
            rentState: tmpRentState,
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
  },
  methods: {
    notify (_title, _msg) {
      this.$notify({
        title: _title,
        message: _msg
      })
    },
    async finishRent (index, rows) {
      if (rows[index].rentType === '借入' || rows[index].tmpRentState === '已到期') {
        await this.$web3.eth.unlockAccount(this.$useraddr, this.$password)
        await this.$instance.endRent(rows[index].account, { from: this.$useraddr })
        rows.splice(index, 1)
      } else {
        this.notify('通知', '账号正在被租用, 不能结束')
      }
    }
  }
}
</script>
