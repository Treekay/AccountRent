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
          <el-form-item label='用户名' v-model="user">
            <el-input></el-input>
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
      if (!this.user) {
        this.notify('通知', '用户名不能为空')
        return false
      } else if (this.user.length < 5) {
        this.notify('通知', '用户名长度小于5')
        return false
      } else {
        return true
      }
    },
    checkPass () {
      if (!this.pass) {
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
        if (!this.pass2) {
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
        console.log(this.$contract)
        let truePassword = await this.$contract.loginCheck(this.user, {from: '0x4551f4742046b365cb3d74327c459627b54a60bb'})
        if (truePassword === this.pass) {
          this.notify('通知', '登录成功')
          this.$router.push('/homePage')
        } else {
          this.notify('通知', '密码错误')
        }
      }
    },
    async signUp (formName) {
      if (this.checkUser() && this.checkPass() && this.checkPass2()) {
        let exist = await this.$contract.checkUserExist(this.user, {from: '0xA3C90D5a5Cd1dC3e1D2a1737c68CBf9bdC507c0a'})
        if (exist === false) {
          if (this.$contract.regist(this.user, this.pass) === true) {
            this.notify('通知', '注册成功')
            this.$router.push('/homePage')
          }
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
