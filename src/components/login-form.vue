<template>
  <div class='formArea'>
    <el-form status-icon label-width='100px' class='demo-ruleForm'>
      <el-tabs type='border-card' :stretch='true' @tab-click='changeState' value='login'>
        <el-tab-pane label='登录' class='rightMargin' name='login'>
          <el-form-item label='用户名'>
            <el-input v-model="user"></el-input>
          </el-form-item>
          <el-form-item label='密码'>
            <el-input type='password' autocomplete='off' v-model="pass"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type='primary' class='btn btn-block btn-lg' @click="signIn">登录</el-button>
          </el-form-item>
        </el-tab-pane>
        <el-tab-pane label='注册' class='rightMargin' name='regist'>
          <el-form-item label='用户名'>
            <el-input v-model="user"></el-input>
          </el-form-item>
          <el-form-item label='密码'>
            <el-input type='password' autocomplete='off' v-model="pass"></el-input>
          </el-form-item>
          <el-form-item label='确认密码'>
            <el-input type='password' autocomplete='off' v-model="pass2"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type='primary' class='btn btn-block btn-lg' @click="signUp">注册</el-button>
          </el-form-item>
        </el-tab-pane>
      </el-tabs>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'signForm',
  data () {
    return {
      state: 'login',
      user: '',
      pass: '',
      pass2: ''
    }
  },
  methods: {
    notify (_title, _msg) {
      this.$notify({
        title: _title,
        message: _msg
      })
    },
    checkUser () {
      if (this.user.length === 0) {
        this.notify('通知', '用户名不能为空')
        return false
      } else {
        return true
      }
    },
    checkPass () {
      if (this.pass.length === 0) {
        this.notify('通知', '密码不能为空')
        return false
      } else {
        return true
      }
    },
    checkPass2 () {
      if (this.state === 'login') {
        return true
      } else {
        if (this.pass2.length === 0) {
          this.notify('通知', '请输入确认密码')
          return false
        } else if (this.pass2 !== this.pass) {
          this.notify('通知', '两次输入密码不一致!')
          return false
        } else {
          return true
        }
      }
    },
    changeState (tab, event) {
      if (this.state === 'regist' && tab.name === 'login') {
        this.state = 'login'
      } else if (this.state === 'login' && tab.name === 'regist') {
        this.state = 'regist'
      }
      this.user = ''
      this.pass = ''
      this.pass2 = ''
    },
    async signIn (formName) {
      if (this.checkUser() && this.checkPass()) {
        const self = this
        let exist = await self.$instance.getUserExist(self.user)
        if (exist === true) {
          let truePassword = await self.$instance.getUserPassword(self.user)
          if (truePassword === self.pass) {
            console.log('登录成功')
            self.notify('通知', '登录成功')
            self.$user.$username = self.user
            self.$user.$password = self.pass
            self.$user.$useraddr = await self.$instance.getUserAddress(self.user)
            self.$router.push('/homePage')
          } else {
            self.notify('通知', '密码错误')
          }
        } else {
          self.notify('通知', '该用户名不存在')
        }
      }
    },
    async signUp (formName) {
      if (this.checkUser() && this.checkPass() && this.checkPass2()) {
        const self = this
        let exist = await self.$instance.getUserExist(self.user)
        if (exist === false) {
          let newAccountAddress = await self.$web3.eth.personal.newAccount(this.pass)
          await this.$web3.eth.personal.unlockAccount(this.$sponsor, '')
          self.$instance.regist(self.user, self.pass, newAccountAddress, { from: self.$sponsor }).then(() => {
            console.log('注册成功')
            self.notify('通知', '注册成功')
            self.$user.$username = self.user
            self.$user.$password = self.pass
            self.$user.$useraddr = newAccountAddress
            self.$router.push('/homePage')
          })
        } else {
          this.notify('通知', '用户名已被注册')
        }
      }
    }
  }
}
</script>

<style>
.formArea {
  margin: 0 auto;
  position: relative;
  height: 100%;
  width: 50%;
  padding: 50px;
  margin-top: 100px;
}
.rightMargin {
  margin-right: 80px;
}
</style>
