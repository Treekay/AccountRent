pragma solidity ^0.4.17;
// pragma experimental ABIEncoderV2;

contract AccountRent {
    // free 表示账号没有被租用， occupy 表示账号正在被请求或正在被租用
    enum accountState {free, occupy}

    // unconfirm表示交易正在请求，confirm表示交易已被确认许可，end表示交易已经结束
    enum rentState {unconfirm, confirm, end}

    struct rent {
        address renterAddress;  // 租借人的地址信息
        uint id;                // 租借的账号号码
        uint rentTime;          // 租借的时长
        uint beginTime;         // 租借的开始时间
        uint endTime;           // 租借结束时间
        uint cost;              // 租借总费用
        rentState state;        // 该笔交易当前所处的状态
    }

    struct account {
        address ownerAddress;   // 账号主人的地址信息
        uint id;                // 账号号码
        string password;        // 账号密码
        uint price;             // 账号单位时间的租借价格
        string accountType;     // 账号类型
        string description;     // 描述该账号
        accountState state;     // 账号的当前状态
    }

    /******用户******/
    // 合法判断
    mapping (string => bool) userExist;
    function getUserExist(string _username) public view returns (bool) {
        return userExist[_username];
    }
    // 用户地址
    mapping (string => address) userAddress;
    function getUserAddress(string _username) public view returns (address) {
        return userAddress[_username];
    }
    // 用户密码
    mapping (string => string) userPassword;
    function getUserPassword(string _username) public view returns (string) {
        return userPassword[_username];
    }
    /****************/

    // 注册用户
    function regist(string _username, string _password, address _userAddress) public {
        if (userExist[_username] == false) {
            userExist[_username] = true;
            userPassword[_username] = _password;
            userAddress[_username] = _userAddress;
        }
    }

    /******账号******/
    // 合法判断
    mapping (uint => bool) public existAccount;
    // 实际存储位置
    mapping (uint => account) public accountPool;
    // 记录已发布的账号
    uint[] accountList;
    function getAccountList() public view returns (uint[]) {
        return accountList;
    }
    /****************/

    /******交易******/
    // 合法判断
    mapping (uint => bool) public existRent;
    // 交易池，存有该合约上每个存在的账号最近的一次交易信息
    mapping (uint => rent) public rentPool;
    // 记录已有的交易
    uint[] rentList;
    function getRentList() public view returns (uint[]) {
        return rentList;
    }
    /***************/

    // 通知事件，主要用于通知交易相关人交易情况
    event notice(address addr, string message);

    // 判断是否存在该账号并且是该账号的主人
    modifier onlyOwner(uint _id) {
        require(existAccount[_id] && accountPool[_id].ownerAddress == msg.sender,
            "Please check the ID, it seems that this account isn't exist or you are not the owner of this account");
        _;
    }

    // 判断是否存在该账号并且是该账号当前的租借人
    modifier onlyRenter(uint _id) {
        require(existAccount[_id] && rentPool[_id].renterAddress == msg.sender,
            "Please check the ID, it seems that this account isn't exist or you are not the renter of this account");
        _;
    }

    /**
     * description: 发起租借某个账号的请求，所有人都能调用这个函数
     * param _id: 要租借的账号
     * param _rentTime: 要租借的时长，这里用的是秒，应用页面选择中可以选择分钟/小时/天等，转换成秒数再传递给该函数
     */
    function createRent(uint _id, uint _rentTime) public payable {
        // 前提条件是该账号没有在被租用或者没有人正在请求该账号
        require(accountPool[_id].state == accountState.free);
        // 创建新交易
        rent memory newRent = rent({
            renterAddress: msg.sender,
            id: _id,
            rentTime: _rentTime,
            state: rentState.unconfirm,
            beginTime: 0,
            endTime: 0,
            cost: accountPool[_id].price * _rentTime * 1 ether
        });
        // 要求账号内有足够的预订金额, 将预订金额转到合约上
        require(msg.value == newRent.cost); 
        // 将交易放到交易池中
        existRent[_id] = true;
        rentPool[_id] = newRent;
        rentList.push(_id);
        // 将账号状态设置为被占有，阻止其他用户同时请求租借该账号，先到先得原则，除非号主拒绝他的请求
        accountPool[_id].state = accountState.occupy;
        // 通知账号主人有人正在请求他的这个账号
        emit notice(accountPool[_id].ownerAddress, "Someone require to rent your account\n");
    }

    /**
     * description: 号主接收某个用户对该账号的租借请求，只有账号所有者能调用该函数
     * param _id：账号号码
     */
    function confirmRent(uint _id) public onlyOwner(_id) returns (string) {
        // 前提条件是存在该交易
        require(rentPool[_id].state == rentState.unconfirm); 
        // 正式确定交易内容
        rentPool[_id].state = rentState.confirm;
        rentPool[_id].beginTime = now;
        rentPool[_id].endTime = now + rentPool[_id].rentTime;
        // 从合约转钱给售号人
        accountPool[_id].ownerAddress.transfer(rentPool[_id].cost);
        // 自动生成密码
        emit notice(rentPool[_id].renterAddress, "Rent success, please change password by yourself\n");
    }

    /**
     * description: 号主拒绝某个用户对该账号的租借请求，只有账号所有者能调用该函数
     * param _id: 账号号码
     */
    function refuseRent(uint _id) public onlyOwner(_id) {
        // 前提条件是存在该交易且该交易处于未确认状态
        require(rentPool[_id].state == rentState.unconfirm); 
        // 拒绝该交易，修改交易状态为结束，修改账号状态为空闲
        rentPool[_id].state == rentState.end;
        accountPool[_id].state = accountState.free;
        // 退预订费给租借人
        rentPool[_id].renterAddress.transfer(rentPool[_id].cost);
        // 删除该交易
        delete rentPool[_id];
        delete existRent[_id];
        // 通知交易发起者，交易被拒绝
        emit notice(rentPool[_id].renterAddress, "The owner refuse your rent request\n");
    }

    /**
     * description: 修改账号的密码
     * param _id: 账号号码
     * param _password: 新密码
     */
    function changePassword(uint _id, string _password) public {
        // 身份条件：如果是用户，只有当账号已确认租借给他时才能修改
        //          如果是号主，只有当账号不是正在被租用时才能修改
        require((accountPool[_id].ownerAddress == msg.sender && rentPool[_id].state == rentState.end) ||
            (rentPool[_id].renterAddress == msg.sender && rentPool[_id].state == rentState.confirm));
        accountPool[_id].password = _password; 
    }

    /**
     * description: 获得当前的账号密码
     * param _id: 账号号码
     */
    function getPassword(uint _id) public view returns (string) {
        // 身份条件：如果是用户，只有当账号已确认租借给他时才能修改
        //          如果是号主，只有当账号不是正在被租用时才能修改
        require((accountPool[_id].ownerAddress == msg.sender && rentPool[_id].state == rentState.end) ||
            (rentPool[_id].renterAddress == msg.sender && rentPool[_id].state == rentState.confirm));
        return accountPool[_id].password;
    }

    /**
     * description: 标记交易结束，只有当超过租借时间之后，账号主人才能调用该函数
     * param _id: 账号号码
     */
    function endRent(uint _id) public {
        // 前提条件：超过租借时间，并且是账号主人
        require(existAccount[_id] && accountPool[_id].ownerAddress == msg.sender &&
            (rentPool[_id].state == rentState.unconfirm || now - rentPool[_id].beginTime >= rentPool[_id].rentTime) ||
            existAccount[_id] && rentPool[_id].renterAddress == msg.sender);

        // 修改交易状态为结束，修改账号状态为空闲
        rentPool[_id].state == rentState.end;
        accountPool[_id].state = accountState.free;
        // 删除该交易
        delete rentPool[_id];
        delete existRent[_id];
    }

    /**
     * description: 创建发布自己要出租的账号
     * param _id: 账号号码
     * param _password: 账号密码
     * param _price: 单位时间的价格
     * param _description: 描述账号的平台类型等
     */
    function createAccount(uint _id, string _password, uint _price, string _accountType, string _description) public {
        require(!existAccount[_id]); // 前提条件：账号池中原本没有该账号
        // 创建新账号
        account memory newAccount = account({
            ownerAddress: msg.sender,
            id: _id,
            password: _password,
            price: _price,
            accountType: _accountType,
            description: _description,
            state: accountState.free
        });
        accountList.push(_id);
        // 发布到账号池中
        accountPool[_id] = newAccount;
        // 将账号的存在判断置为真
        existAccount[_id] = true;
    }

    /**
     * description: 从账号池中移除账号，只有账号主人能调用该函数
     * param _id: 账号号码
     */
    function removeAccount(uint _id) public onlyOwner(_id) {
        require(accountPool[_id].state == accountState.free);
        // 从账号池中移除该账号
        delete accountPool[_id];
        delete existAccount[_id];
    }
}