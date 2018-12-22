pragma solidity ^0.4.25;

contract AccountRent {
    // free 表示账号没有被租用， occupy 表示账号正在被请求或正在被租用
    enum accountState {free, occupy}

    // unconfirm表示交易正在请求，confirm表示交易已被确认许可，end表示交易已经结束
    enum rentState {unconfirm, confirm, end}

    struct rent {
        address renterAddress;  // 租借人的地址信息
        string id;              // 租借的账号号码
        uint rentTimes;         // 租借的时长
        uint beginTime;         // 租借的开始时间
        uint cost;              // 租借总费用
        rentState state;        // 该笔交易当前所处的状态
    }

    struct account {
        address ownerAddress;   // 账号主人的地址信息
        string id;              // 账号号码
        string password;        // 账号密码
        uint price;             // 账号单位时间的租借价格
        string description;     // 描述该账号
        accountState state;     // 账号的当前状态
    }

    // 账号池，存有该合约上所有的账号
    mapping(string => account) accountPool;

    // 交易池，存有该合约上每个存在的账号最近的一次交易信息
    mapping(string => rent) rentPool;

    // 账号合法判断，用于判断账号池内是否存在该账号
    mapping(string => bool) validAccounts;

    event notice(address, string); // 通知事件，主要用于通知交易相关人交易情况

    // 判断是否存在该账号并且是该账号的主人
    modifier onlyOwner(string _id) {
        require(
            validAccounts[_id] && accountPool[_id].ownerAddress == msg.sender,
            "Please check the ID, it seems that this account isn't exist or you are not the owner of this account"
        );
        _;
    }

    // 判断是否存在该账号并且是该账号当前的租借人
    modifier onlyRenter(string _id) {
        require(
            validAccounts[_id] && rentPool[_id].renterAddress == msg.sender,
            "Please check the ID, it seems that this account isn't exist or you are not the renter of this account"
        );
        _;
    }

    /**
     * description: 发起租借某个账号的请求，所有人都能调用这个函数
     * param _id: 要租借的账号
     * param _rentTimes: 要租借的时长，这里用的是秒，应用页面选择中可以选择分钟/小时/天等，转换成秒数再传递给该函数
     */
    function createRent(string _id, uint _rentTimes) public payable {
        // 前提条件是该账号没有在被租用或者没有人正在请求该账号
        require(
            accountPool[_id].state == accountState.free,
            ""
        );
        // 创建新交易
        rent memory newRent = rent({
            renterAddress: msg.sender,
            id: _id,
            rentTimes: _rentTimes,
            state: rentState.unconfirm,
            beginTime: 0,
            cost: accountPool[_id].price * _rentTimes * 1 ether
        });
        // 要求账号内有足够的预订金额, 将预订金额转到合约上
        require(
            msg.value == newRent.cost,
            ""
        ); 
        // 将交易放到交易池中
        rentPool[_id] = newRent;
        // 将账号状态设置为被占有，阻止其他用户同时请求租借该账号，先到先得原则，除非号主拒绝他的请求
        accountPool[_id].state = accountState.occupy;
        // 通知账号主人有人正在请求他的这个账号
        emit notice(accountPool[_id].ownerAddress, "Someone require to rent your account\n");
    }

    /**
     * description: 号主接收某个用户对该账号的租借请求，只有账号所有者能调用该函数
     * param _id：账号号码
     */
    function confirmRent(string _id) public onlyOwner(_id) returns (string) {
        // 前提条件是存在该交易
        require(
            rentPool[_id].state == rentState.unconfirm,
            ""
        ); 
        accountPool[_id].ownerAddress.transfer(rentPool[_id].cost);
        rentPool[_id].state = rentState.confirm;
        rentPool[_id].beginTime = now;
        // 自动生成密码
        emit notice(rentPool[_id].renterAddress, "Rent success, please change password by yourself\n");
    }

    /**
     * description: 号主拒绝某个用户对该账号的租借请求，只有账号所有者能调用该函数
     * param _id: 账号号码
     */
    function refuseRent(string _id) public onlyOwner(_id) {
        // 前提条件是存在该交易且该交易处于未确认状态
        require(
            rentPool[_id].state == rentState.unconfirm,
            ""
        ); 

        // 拒绝该交易，则将该交易设置为结束
        rentPool[_id].state == rentState.end;
        accountPool[_id].state = accountState.free;
        // 退换预订费给租借人
        rentPool[_id].renterAddress.transfer(rentPool[_id].cost);
        // 通知交易发起者，交易被拒绝
        emit notice(rentPool[_id].renterAddress, "The owner refuse your rent request\n");
    }

    /**
     * description: 修改账号的密码
     * param _id: 账号号码
     * param _password: 新密码
     */
    function changePassword(string _id, string _password) public {
        // 前提条件：存在该账号，所输入的账号不是空号
        // 身份条件：如果是用户，只有当账号已确认租借给他时才能修改
        //          如果是号主，只有当账号不是正在被租用时才能修改
        require(
            validAccounts[_id] && 
            (accountPool[_id].ownerAddress == msg.sender && rentPool[_id].state == rentState.end) ||
            (rentPool[_id].renterAddress == msg.sender && rentPool[_id].state == rentState.confirm),
            ""
        );
        accountPool[_id].password = _password; 
    }

    /**
     * description: 获得当前的账号密码
     * param _id: 账号号码
     */
    function getPassword(string _id) public view returns (string) {
        // 前提条件：存在该账号，所输入的账号不是空号
        // 身份条件：如果是用户，只有当账号已确认租借给他时才能修改
        //          如果是号主，只有当账号不是正在被租用时才能修改
        require(
            validAccounts[_id] && 
            (accountPool[_id].ownerAddress == msg.sender && rentPool[_id].state == rentState.end) ||
            (rentPool[_id].renterAddress == msg.sender && rentPool[_id].state == rentState.confirm),
            ""
        );
        return accountPool[_id].password;
    }

    /**
     * description: 标记交易结束，只有当超过租借时间之后，账号主人才能调用该函数
     * param _id: 账号号码
     */
    function endRent(string _id) public onlyOwner(_id) {
        // 前提条件：超过租借时间，并且是账号主人
        require(
            rentPool[_id].state == rentState.unconfirm ||
            now - rentPool[_id].beginTime >= rentPool[_id].rentTimes,
            ""
        );

        // 修改交易状态为结束，
        rentPool[_id].state == rentState.end;
        // 修改账号状态为空闲，以便其他人能请求租借该账号
        accountPool[_id].state = accountState.free;
        // 修改账号的密码，不让过期的租借人继续使用
        accountPool[_id].password = "random"; 
    }

    /**
     * description: 创建发布自己要出租的账号
     * param _id: 账号号码
     * param _password: 账号密码
     * param _price: 单位时间的价格
     * param _description: 描述账号的平台类型等
     */
    function createAccount(string _id, string _password, uint _price, string _description) public {
        require(
            !validAccounts[_id],
            ""
        ); // 前提条件：账号池中原本没有该账号
        // 创建新账号
        account memory newAccount = account({
            ownerAddress: msg.sender,
            id: _id,
            password: _password,
            price: _price,
            description: _description,
            state: accountState.free
        });
        // 发布到账号池中
        accountPool[_id] = newAccount;
        // 将账号的存在判断置为真
        validAccounts[_id] = true;
    }

    /**
     * description: 从账号池中移除账号，只有账号主人能调用该函数
     * param _id: 账号号码
     */
    function removeAccount(string _id) public onlyOwner(_id) {
        require(
            accountPool[_id].state == accountState.free,
            ""
        );
        // 从账号池中移除该账号
        delete accountPool[_id];
        // 账号存在标记设为false
        validAccounts[_id] = false;
    }

    /**
     * description: 获得该账号的当前状态
     * param _id: 账号号码
     * return accountState: 账号的状态信息
     */
    function getAccountState(string _id) public view returns (accountState) {
        require(
            validAccounts[_id],
            ""
        ); // 前提条件：该账号存在账号池中
        // 返回该账号的当前状态
        return accountPool[_id].state;
    }

}