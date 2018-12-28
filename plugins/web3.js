import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'
import accountRentArtifact from '../build/contracts/AccountRent.json'

export default {
  install: async function (Vue) {
    // Modern dapp browsers...
    var web3Provider = null
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
      web3Provider = new Web3.providers.HttpProvider('http://localhost:7545')
    }
    let web3 = new Web3(web3Provider)
    Vue.prototype.$web3 = web3

    // 初始化合约对象
    let instance = contract(accountRentArtifact)
    instance.setProvider(web3.currentProvider)
    try {
      instance = await instance.deployed()
    } catch (err) {
      console.log(err)
    }
    Vue.prototype.$instance = instance
    console.log(Vue.prototype.$instance)
  }
}