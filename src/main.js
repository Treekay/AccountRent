// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import web3Plugin from './plugins/web3'

Vue.use(ElementUI)
Vue.use(web3Plugin)
Vue.prototype.$username = ''
Vue.prototype.$password = ''
Vue.prototype.$useraddr = ''

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
