<template>
  <div class="leftPart">
    <h2 id="headline">在售账号</h2>
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
        prop="description"
        label="账号类型"
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
          <el-button type="text" size="small">添加</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'accountSale',
  data () {
    return {
      tableData: [{
        account: '823334594',
        description: '666',
        accountStatus: '空闲',
        price: '20'
      }, {
        account: '2295507969',
        description: '666',
        accountStatus: '空闲',
        price: '20'
      }, {
        account: '3188088288',
        description: '666',
        accountStatus: '空闲',
        price: '20'
      }, {
        account: '72930215',
        description: '666',
        accountStatus: '空闲',
        price: '20'
      }, {
        account: '85255563',
        description: '666',
        accountStatus: '空闲',
        price: '20'
      }, {
        account: '633325112',
        description: '666',
        accountStatus: '空闲',
        price: '20'
      }, {
        account: '889554631',
        description: '666',
        accountStatus: '空闲',
        price: '20'
      }]
    }
  },
  methods: {
    getMyAccounts () {

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
