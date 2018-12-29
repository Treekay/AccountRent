<template>
  <div class="leftPart">
    <h2 id="headline">在售账号</h2>
    <el-table :data="tableData" stripe style="width: 100%">
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
  mounted: async () => {
    let accounts = await this.$instance.getAccounts()
    for (let i = 0; i < accounts.length; i++) {
      if (accounts[i].state === 0) {
        this.tableData.append({
          account: accounts[i].id,
          accountType: accounts[i].accountType,
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
