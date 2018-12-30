<template>
  <div class="container">
    <h2>交易记录</h2>
    <el-table :data="tableData" style="width: 100%">
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
  mounted: async function () {
    let rents = await this.$instance.getRentList()
    for (var i = 0; i < rents.length; i++) {
      let exist = await this.$instance.existRent(rents[i])
      if (exist) {
        let tmpRent = await this.$instance.rentPool(rents[i])
        if (tmpRent.state === 1) {
          let tmpAccount = await this.$instance.accountPool(rents[i])
          if (tmpRent.renterAddress === this.$user.$useraddr || tmpAccount.ownerAddress === this.$user.$useraddr) {
            let tmpRentType
            if (tmpAccount.ownerAddress === this.$user.$useraddr) {
              tmpRentType = '借出'
            } else {
              tmpRentType = '借入'
            }
            let tmpRentState
            if ((new Date()).valueOf() >= tmpRent.endTime) {
              tmpRentState = '已到期'
            } else {
              tmpRentState = '使用中'
            }
            this.tableData.append({
              account: tmpAccount.id,
              rentType: tmpRentType,
              startTime: tmpRent.beginTime,
              endTime: tmpRent.endTime,
              accountType: tmpAccount.accountType,
              cost: tmpRent.cost,
              rentState: tmpRentState,
              description: tmpAccount.description
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
    notify (_title, _msg) {
      this.$notify({
        title: _title,
        message: _msg
      })
    },
    async finishRent (index, rows) {
      if (rows[index].rentType === '借入' || rows[index].tmpRentState === '已到期') {
        await this.$web3.eth.personal.unlockAccount(this.$user.$useraddr, this.$user.$password)
        await this.$instance.endRent(rows[index].account, { from: this.$user.$useraddr })
        rows.splice(index, 1)
      } else {
        this.notify('通知', '账号正在被租用, 不能结束')
      }
    }
  }
}
</script>
