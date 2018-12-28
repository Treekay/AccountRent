<template>
  <div class="rightPart">
    <h2>租借账号</h2>
    <el-form status-icon label-width="70px" class="demo-ruleForm">
      <el-form-item label="账号" prop="account">
        <input class="detailBox"/>
      </el-form-item>
      <el-form-item label="租借天数" prop="rentTime">
        <input class="detailBox"/>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" class="btn btn-block btn-lg" @click="submit">确认</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'accountBuy',
  data () {
    return {
      account: '',
      rentTime: ''
    }
  },
  methods: {
    notify (_title, _msg) {
      this.$notify({
        title: _title,
        message: _msg
      })
    },
    async submit () {
      await this.$web3.eth.unlockAcccount(this.$useraddr, this.$password)
      let tmpAccountPrice = await this.$instance.accountPool(this.account).price * this.rentTime
      await this.$instance.createRent.sendTransaction(this.account, this.rentTime, {
        from: this.$sponsor, value: this.$web3.fromWei(tmpAccountPrice)
      })
      this.notify('通知', '预订发送成功')
      this.$router.push('/homePage')
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
}
.detailBox {
  height: 40px;
  width: 100%;
  text-align: left;
  line-height: 40px;
  vertical-align: middle;
  border: lightgray solid 1px;
}
</style>
