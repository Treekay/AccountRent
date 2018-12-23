// Import the page's CSS. Webpack will know what to do with it.
import '../styles/app.css'

// Import libraries we need.
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import AccountRentArtifact from '../../build/contracts/AccountRent.json'

// AccountRent is our usable abstraction, which we'll use through the code below.
const AccountRent = contract(AccountRentArtifact)

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
let accounts
let account

const App = {
  start: function () {
    const self = this

    // Bootstrap the AccountRent abstraction for Use.
    AccountRent.setProvider(web3.currentProvider)

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function (err, accs) {
      if (err != null) {
        alert('There was an error fetching your accounts.')
        return
      }

      if (accs.length === 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.")
        return
      }

      accounts = accs
      account = accounts[0]

      self.refreshBalance()
    })

    if ('content' in document.createElement('template')) {
      // 使用现有的HTML tbody实例化表和该行与模板
      let t = document.querySelector('#account');
      let head = t.content.getElementsByClassName('panel-heading');
      let body = t.content.getElementsByClassName('panel-body');
      let foot = t.content.getElementsByClassName('panel-footer');

      head[0].value = 'LOL账号'
      body[0].value = '全英雄, 一区钻石3'
      foot[0].value = '￥2/h'

      // 克隆新行并将其插入表中
      let saleBoard = document.getElementById("saleBoard");
      let newAccount = document.importNode(t.content, true);
      saleBoard.appendChild(newAccount);
    }
  },

  showOwnAccounts: function () {
    const head = document.getElementById('headBoard')
    head.innerHTML = 'My Accounts'

  },

  showRentHistory: function () {
    const head = document.getElementById('headBoard')
    head.innerHTML = 'Rents History'

  },

  toHomePage: function () {
    const head = document.getElementById('headBoard')
    head.innerHTML = 'On Sale'

  },

  toLoginPage: function() {

  },

  toDetailPage: function() {
    const head = document.getElementById('headBoard')
    head.innerHTML = 'Details'

  },

  checkInforms: function() {
    const head = document.getElementById('headBoard')
    head.innerHTML = 'Informs'

  }
}

window.App = App

window.addEventListener('load', function () {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn(
      'Using web3 detected from external source.' +
      ' If you find that your accounts don\'t appear or you have 0 AccountRent,' +
      ' ensure you\'ve configured that source properly.' +
      ' If using MetaMask, see the following link.' +
      ' Feel free to delete this warning. :)' +
      ' http://truffleframework.com/tutorials/truffle-and-metamask'
    )
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider)
  } else {
    console.warn(
      'No web3 detected. Falling back to http://127.0.0.1:9545.' +
      ' You should remove this fallback when you deploy live, as it\'s inherently insecure.' +
      ' Consider switching to Metamask for development.' +
      ' More info here: http://truffleframework.com/tutorials/truffle-and-metamask'
    )
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:9545'))
  }

  App.start()
})
