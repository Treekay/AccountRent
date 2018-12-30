<template>
  <div class="leftPart">
    <h2 id="headline">在售账号</h2>
    <el-table :data="tableData" style="width: 100%">
      <el-table-column prop="account" label="账号" width="120px"></el-table-column>
      <el-table-column prop="accountType" label="账号类型" width="120px"></el-table-column>
      <el-table-column prop="description" label="账号描述" width="300px"></el-table-column>
      <el-table-column prop="price" label="价格" width="100px"></el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'accountSale',
  mounted: async function () {
    let accounts = await this.$instance.getAccountList()
    for (let i = 0; i < accounts.length; i++) {
      let accountExist = await this.$instance.existAccount(accounts[i])
      if (accountExist) {
        let tmpAccount = await this.$instance.accountPool(accounts[i])
        if (tmpAccount.state === 0) {
          this.tableData.append({
            account: tmpAccount.id,
            accountType: tmpAccount.accountType,
            description: tmpAccount.description,
            price: tmpAccount.price
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

<style>
.leftPart {
  float: left;
  width: 50%;
  margin-left: 8%;
  opacity: .8;
}
#headline {
  float: left;
}
</style>
