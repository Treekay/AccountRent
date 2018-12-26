// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '5777'
    }
  },
  compilers: {
    solc: {
      version: "0.4.20"  // ex:  "0.4.20". (Default: Truffle's installed solc)"
    }
  }
}
