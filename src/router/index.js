import Vue from 'vue'
import Router from 'vue-router'
import loginPage from '@/pages/loginPage'
import homePage from '@/pages/homePage'
import minePage from '@/pages/minePage'
import rentsPage from '@/pages/rentsPage'
import historyPage from '@/pages/historyPage'
import notifyPage from '@/pages/notifyPage'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      component: loginPage
    },
    {
      path: '/homePage',
      component: homePage
    },
    {
      path: '/minePage',
      component: minePage
    },
    {
      path: '/rentsPage',
      component: rentsPage
    },
    {
      path: '/historyPage',
      component: historyPage
    },
    {
      path: '/notifyPage',
      component: notifyPage
    }
  ]
})
