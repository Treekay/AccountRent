<template>
  <div class="leftPart">
    <h2 id="headline">我的账号</h2>
    <el-table
      :data="tableData"
      stripe
      style="width: 100%">
      <el-table-column
        prop="account"
        label="账号"
        width="120px">
      </el-table-column>
      <el-table-column
        prop="accountState"
        label="账号状态"
        width="120px">
      </el-table-column>
      <el-table-column
        prop="description"
        label="账号描述"
        width="250px">
      </el-table-column>
      <el-table-column
        prop="price"
        label="价格"
        width="100px">
      </el-table-column>
      <el-table-column
        label="操作"
        width="60px">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click='remove(scope.$index, tableData)'>删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'accountMine',
  mounted: async function () {
    this.tableData = []
    let accounts = await this.$instance.getAccounts()
    for (let i = 0; i < accounts.length; i++) {
      if (accounts[i].ownerAddress === this.$useraddr) {
        let tmpAccountState
        if (accounts[i].accountState === 0) {
          tmpAccountState = '空闲'
        } else {
          tmpAccountState = '出租中'
        }
        this.tableData.append({
          account: accounts[i].id,
          accountState: tmpAccountState,
          description: accounts[i].description,
          price: accounts[i].price
        })
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
    async remove (index, rows) {
      if (rows[index].accountState === '空闲') {
        await this.$web3.eth.unlockAccount(this.$useraddr, this.$password)
        await this.$instance.removeAccount(rows[index].account, { from: this.$useraddr })
        rows.splice(index, 1)
      } else {
        this.notify('通知', '账号正在被租用, 不能删除')
      }
    }
  }
}
</script>

<style>
.leftPart {
  float: left;
  width: 50%;
  margin-left: 8%;
}
#headline {
  float: left;
}
</style>
