<template>
  <div class="navbar navbar-default">
    <div class="container">
      <div class="navbar-header">
        <router-link to="homePage" class="navbar-brand">AccountRent</router-link>
      </div>
      <ul class="nav navbar-nav">
        <li><router-link to="myAccounts">myAccounts</router-link></li>
        <li><router-link to="myRents">myRents</router-link></li>
      </ul>
      <form class="navbar-form navbar-left">
        <div class="form-group">
          <input type="text" class="form-control" id="searchbox" :value="searchText">
        </div>
        <button type="submit" class="btn btn-default" @click="searchSaleAccounts()">Search</button>
      </form>
    </div>
  </div>
</template>

<script>
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

import accountRentArtifact from '../../build/contracts/AccountRent.json'

export default {
  name: 'topNav',
  mounted: function () {
    this.AccountRent = contract(accountRentArtifact)
    this.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545'))
  },
  data () {
    return {
      web3: null,
      accounts: [],
      searchText: ''
    }
  },
  methods: {
    searchSaleAccounts () {

    }
  }
}
</script>
