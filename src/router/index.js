import Vue from 'vue'
import Router from 'vue-router'
import accountList from '@/components/account-table'
import rentList from '@/components/rent-table'
import signForm from '@/components/sign-form'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      component: signForm
    },
    {
      path: '/myAccounts',
      component: accountList
    },
    {
      path: '/myRents',
      component: rentList
    }
  ]
})
