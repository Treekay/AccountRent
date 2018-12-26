var AccountRent = artifacts.require("./AccountRent.sol");

module.exports = function(deployer) {
  deployer.deploy(AccountRent);
};
