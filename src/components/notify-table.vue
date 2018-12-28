<template>
  <div class="container">
    <h2>租借请求</h2>
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
        prop="rentTime"
        label="租借时长"
        width="200px">
      </el-table-column>
      <el-table-column
        prop="cost"
        label="金额"
        width="80px">
      </el-table-column>
      <el-table-column
        prop="commit"
        label="备注">
      </el-table-column>
      <el-table-column
        label="操作"
        width="100px">
        <template slot-scope="scope">
          <el-button type="text" size="small">同意</el-button>
          <el-button type="text" size="small">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'notify',
  data () {
    return {
      tableData: [{
        account: '823334594',
        startTime: '2018-12-10',
        endTime: '2018-12-12',
        rentType: '借出',
        rentStatus: '已完成'
      }, {
        account: '2295507969',
        startTime: '2018-12-10',
        endTime: '2018-12-12',
        rentType: '借出',
        rentStatus: '已完成'
      }, {
        account: '3188088288',
        startTime: '2018-12-10',
        endTime: '2018-12-12',
        rentType: '借出',
        rentStatus: '已完成'
      }, {
        account: '72930215',
        startTime: '2018-12-10',
        endTime: '2018-12-12',
        rentType: '借入',
        rentStatus: '未确认'
      }, {
        account: '954885561',
        startTime: '2018-12-10',
        endTime: '2018-12-12',
        rentType: '借出',
        rentStatus: '已完成'
      }, {
        account: '754421662',
        startTime: '2018-12-10',
        endTime: '2018-12-28',
        rentType: '借入',
        rentStatus: '使用中'
      }, {
        account: '2135652225',
        startTime: '2018-12-10',
        endTime: '2018-12-31',
        rentType: '借入',
        rentStatus: '使用中'
      }]
    }
  },
  methods: {
    getMyAccounts () {

    }
  }
}
</script>
