import Vue from 'vue'
import Router from 'vue-router'
import accountMine from '@/components/account-mine'
import accountCreate from '@/components/account-create'
import accountBuy from '@/components/account-buy'
import accountSale from '@/components/account-sale'
import rentTable from '@/components/rent-table'
import loginForm from '@/components/login-form'
import notify from '@/components/notify-table'
import topNav from '@/components/top-nav'
import history from '@/components/rent-history'

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
        default: accountMine,
        rightPart: accountCreate
      }
    },
    {
      path: '/myRents',
      components: {
        header: topNav,
        default: rentTable
      }
    },
    {
      path: '/history',
      components: {
        header: topNav,
        default: history
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
