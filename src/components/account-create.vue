<template>
  <div class="rightPart">
    <h2>发布账号</h2>
    <el-form status-icon label-width="70px" class="demo-ruleForm">
      <el-form-item label="账号">
        <el-input v-model='account'></el-input>
      </el-form-item>
      <el-form-item label="价格">
        <el-input v-model='price'></el-input>
      </el-form-item>
      <el-form-item label="账号类型">
        <el-input v-model='accountType'></el-input>
      </el-form-item>
      <el-form-item label="账号描述">
        <el-input v-model='description'></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click='create'>确认</el-button>
        <el-button>取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'accountCreate',
  data () {
    return {
      account: '',
      price: '',
      accountType: '',
      description: ''
    }
  },
  methods: {
    notify (_title, _msg) {
      this.$notify({
        title: _title,
        message: _msg
      })
    },
    async create () {
      await this.$web3.eth.unlockAccount(this.$useraddr, this.$password)
      let accountExist = await this.$instance.checkAccountExist(this.account)
      if (accountExist) {
        let randomPass = Math.random().toString(36).substr(2)
        await this.$instance.createAccount(this.account, randomPass, this.price, this.accountType, this.description, { from: this.$useraddr })
        this.$router.push('/myAccounts')
      }
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
