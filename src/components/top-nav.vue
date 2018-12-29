<template>
  <div class="navbar navbar-default">
    <div class="container">
      <div class="navbar-header">
        <router-link to="/homePage" class="navbar-brand">AccountRent</router-link>
      </div>
      <ul class="nav navbar-nav">
        <li><router-link to="/myAccounts">我的账号</router-link></li>
        <li><router-link to="/myRents">租用账号</router-link></li>
        <li><router-link to="/history">交易记录</router-link></li>
      </ul>
      <form class="navbar-form navbar-right">
        <router-link to="/">
          <el-badge class="item">
            <el-button type="primary" size="small">退出</el-button>
          </el-badge>
        </router-link>
        <router-link to="/notify">
          <el-badge :value="notifyNum" class="item">
            <el-button size="small">通知</el-button>
          </el-badge>
        </router-link>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'topNav',
  mounted: async () => {
    this.notifyNum = 0
    let allRents = await this.$instance.getRents()
    for (var i = 0; i < allRents.length; i++) {
      if (allRents.state === 0) {
        let owner = await this.$instance.getAccount(allRents[i].id)
        let ownerAddress = await this.$instance.getUserAddress(owner)
        if (ownerAddress === this.$useraddr) {
          this.notifyNum++
        }
      }
    }
  },
  data () {
    return {
      notifyNum: 0
    }
  }
}
</script>

<style>
#notify {
  text-decoration-line: none;
  color: gray;
}
</style>
