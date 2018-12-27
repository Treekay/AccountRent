<template>
  <div class="container">
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
        prop="renterAddress"
        label="租借人"
        width="230px">
      </el-table-column>
      <el-table-column
        prop="times"
        label="时间"
        width="120px">
      </el-table-column>
      <el-table-column
        prop="status"
        label="交易状态">
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'rentList',
  data () {
    return {
      tableData: [{
        account: '2016-05-02',
        times: '王小虎',
        renterAddress: '上海市普陀区金沙江路 1518 弄',
        status: '已完成'
      }, {
        account: '2016-05-04',
        times: '王小虎',
        renterAddress: '上海市普陀区金沙江路 1517 弄',
        status: '已完成'
      }, {
        account: '2016-05-01',
        times: '王小虎',
        renterAddress: '上海市普陀区金沙江路 1519 弄',
        status: '已完成'
      }, {
        account: '2016-05-03',
        times: '王小虎',
        renterAddress: '上海市普陀区金沙江路 1516 弄',
        status: '已完成'
      }, {
        account: '2016-05-04',
        times: '王小虎',
        renterAddress: '上海市普陀区金沙江路 1517 弄',
        status: '已完成'
      }, {
        account: '2016-05-01',
        times: '王小虎',
        renterAddress: '上海市普陀区金沙江路 1519 弄',
        status: '已完成'
      }, {
        account: '2016-05-03',
        times: '王小虎',
        renterAddress: '上海市普陀区金沙江路 1516 弄',
        status: '已完成'
      }]
    }
  },
  methods: {
    getMyAccounts () {

    }
  }
}
</script>
