# AccountRent
## 使用说明

### 环境配置

- 在项目目录下执行`npm install`安装所需的module，需要安装的modules较多，详见`package.json`
- 修改`truffle.js`中的主机地址、端口和网络id
- 修改`/plugins/web3.js`中的`Vue.prototype.$sponsor`，改成运行合约的私链上的账户；新注册用户会`newAccount`一个新的合约账号地址，新的账号需要先挖到矿才有足够的钱调用合约，`$sponsor`用在注册时以及一些不涉及交易的合约函数调用中，以便有足够的钱

### 编译部署

- 在项目目录下执行`truffle compile`进行编译，需要的`truffle`版本为`4.1.13`，`solidity`版本为`0.4.24`，`web3`版本为`1.0.0-beta.37`，版本不对应可能造成各种错误
- 在项目目录下执行`truffle migrate`进行部署，部署过程中需要`unlockAccount`私链上的账号并进行挖矿，部署过程有可能出现`gas limit`或`gas too low`问题，需要调整`truffle.js`中的`gas`或者重新设置私链的`gasLimit`

### 运行

- 在项目目录下执行`npm run dev`之后，在浏览器打开`localhost:8080`可以看到运行结果
- 执行过程中调用一些功能需要`unlockAccount`并开启挖矿才能往下执行