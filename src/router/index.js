import Vue from 'vue'
import Router from 'vue-router'
import accountList from '@/components/account-table'
import accountManage from '@/components/account-manage'
import accountBuy from '@/components/account-buy'
import accountSale from '@/components/account-sale'
import rentList from '@/components/rent-table'
import loginForm from '@/components/login-form'
import notify from '@/components/notify-table'
import topNav from '@/components/top-nav'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      component: loginForm
    },
    {
      path: '/myAccounts',
      components: {
        header: topNav,
        default: accountList,
        rightPart: accountManage
      }
    },
    {
      path: '/myRents',
      components: {
        header: topNav,
        default: rentList
      }
    },
    {
      path: '/homePage',
      components: {
        header: topNav,
        default: accountSale,
        rightPart: accountBuy
      }
    },
    {
      path: '/notify',
      components: {
        header: topNav,
        default: notify
      }
    }
  ]
})
