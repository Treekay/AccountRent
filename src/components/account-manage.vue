<template>
  <div class="rightPart">
    <h2>新建账号</h2>
    <el-form status-icon label-width="70px" class="demo-ruleForm">
      <el-form-item label="账号" prop="account">
        <el-input></el-input>
      </el-form-item>
      <el-form-item label="价格" prop="price">
        <el-input></el-input>
      </el-form-item>
      <el-form-item label="账号类型" prop="accountType">
        <el-input></el-input>
      </el-form-item>
      <el-form-item label="账号描述" prop="description">
        <el-input></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary">创建</el-button>
        <el-button>取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'accountManage',
  data () {
    return {
      account: '823334594',
      price: '20',
      accountType: 'LOL',
      description: '666'
    }
  }
}
</script>

<style>
.rightPart {
  border: 1px solid lightgray;
  padding: 10px 20px;
  vertical-align: middle;
  float: right;
  width: 30%;
  margin-right: 8%;
  margin-top: 20px;
}
</style>
