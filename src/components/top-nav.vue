<template>
  <div class="navbar navbar-default">
    <div class="container">
      <div class="navbar-header">
        <router-link to="/homePage" class="navbar-brand" id="title">
          <span id="leftF">Account</span>
          <span id="rightF">Rent</span>
        </router-link>
      </div>
      <ul class="nav navbar-nav">
        <li><router-link to="/minePage">我的账号</router-link></li>
        <li><router-link to="/rentsPage">租用账号</router-link></li>
        <li><router-link to="/historyPage">交易记录</router-link></li>
      </ul>
      <form class="navbar-form navbar-right">
        <router-link to="/">
          <el-badge class="item">
            <el-button type="primary" size="small">退出</el-button>
          </el-badge>
        </router-link>
        <router-link to="/notifyPage">
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
  mounted: async function () {
    let rents = await this.$instance.getRentList()
    for (var i = 0; i < rents.length; i++) {
      let exist = await this.$instance.existRent(rents[i])
      if (exist) {
        let tmpRent = await this.$instance.rentPool(rents[i])
        if (tmpRent.state === 0) {
          let ownerAddress = this.$instance.accountPool(tmpRent.id).ownerAddress
          if (ownerAddress === this.$user.$useraddr) {
            this.notifyNum++
          }
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
}
#leftF {
  color: orange;
  margin-right: -2px;
  font-size: x-large;
}
#rightF {
  color: lightseagreen;
  margin-left: -2px;
  font-size: x-large;
}
</style>
