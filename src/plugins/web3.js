import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'
import accountRentArtifact from '../../build/contracts/AccountRent'

export default {
  install: async function (Vue) {
    // Modern dapp browsers...
    let web3Provider = null
    if (window.ethereum) {
      web3Provider = window.ethereum
      try {
        // Request account access
        await window.ethereum.enable()
      } catch (error) {
        // User denied account access...
        // eslint-disable-next-line no-console
        console.error('User denied account access')
      }
    } else if (window.web3) {
      // Legacy dapp browsers...
      web3Provider = window.web3.currentProvider
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545')
    }
    Vue.prototype.$web3 = new Web3(web3Provider)
    console.log('get web3: ', Vue.prototype.$web3)

    // 初始化合约对象
    let AccountRent = contract(accountRentArtifact)
    AccountRent.setProvider(Vue.prototype.$web3.currentProvider)
    AccountRent.currentProvider.sendAsync = function () {
      return AccountRent.currentProvider.send.apply(AccountRent.currentProvider, arguments)
    }

    // 获得合约实体
    AccountRent.deployed().then((temp) => {
      Vue.prototype.$instance = temp
      console.log('get instance: ', Vue.prototype.$instance)
    }).catch((err) => {
      console.log(err)
    })

    // 合约发起人地址
    Vue.prototype.$sponsor = '0xf9a1ff3a235cd6020bf710e6a893a53776efcb5d'
  }
}
