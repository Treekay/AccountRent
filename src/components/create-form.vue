<template>
  <div class="createPart">
    <h2>发布账号</h2>
    <el-form status-icon label-width="70px" class="demo-ruleForm">
      <el-form-item label="账号">
        <el-input v-model='account' type="number"></el-input>
      </el-form-item>
      <el-form-item label="价格">
        <el-input v-model='price' type="number"></el-input>
      </el-form-item>
      <el-form-item label="账号类型">
        <el-input v-model='accountType'></el-input>
      </el-form-item>
      <el-form-item label="账号描述">
        <el-input v-model='description'></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="warning" class="btn btn-block btn-lg" @click='create'>确认</el-button>
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
      await this.$web3.eth.personal.unlockAccount(this.$user.$useraddr, this.$user.$password)
      await this.$web3.eth.personal.unlockAccount(this.$sponsor, '')
      let accountExist = await this.$instance.existAccount(this.account)
      if (accountExist === false) {
        let randomPass = Math.random().toString(36).substr(2)
        console.log('等待发布')
        try {
          let tmp = await this.$instance.createAccount(this.account, randomPass, this.price, this.accountType, this.description, { from: this.$sponsor })
          console.log('发布成功')
          console.log(tmp)
          this.notify('通知', '发布成功')
          this.account = ''
          this.price = ''
          this.accountType = ''
          this.description = ''
        } catch (e) {
          console.log(e)
          this.notify('错误', '发布未成功')
        }
      } else {
        this.notify('错误', '该账号已存在')
      }
    }
  }
}
</script>

<style>
.createPart {
  border: 1px solid lightgray;
  padding: 10px 20px;
  vertical-align: middle;
  float: right;
  width: 30%;
  margin-right: 8%;
  margin-top: 20px;
  background: white;
  margin-top: 60px;
  opacity: .8;
}
</style>
