pragma solidity ^0.4.24;

contract AccountRent {
    enum accountState {free, occupy}
    enum rentState {unconfirm, confirm, end}

    struct rent {
        address renterAddress;
        uint id;
        uint price;
        uint rentDays;
        rentState state;
        uint beginTime;
    }

    struct account {
        address ownerAddress;
        uint id;
        uint password;
        accountState state;
    }

    uint rentCount;
    mapping(uint => account) accounts;
    mapping(uint => rent) rents;
    mapping(uint => bool) validAccounts;

    event message(address _to, string _content, uint _password);
    event notice(address _to, string _content);

    modifier onlyOwner(uint _id) {
        require(validAccounts[_id] && accounts[_id].ownerAddress == msg.sender,
            "Please check the ID, it seems that this ID isn't exist or you are not the owner of this ID");
        _;
    }

    modifier onlyRenter(uint _id) {
        require(validAccounts[_id] && rents[_id].renterAddress == msg.sender,
            "Please check the ID, it seems that this ID isn't exist or you are not the renter of this ID");
        _;
    }

    function request(uint _id, uint _rentDays, uint _price) public {
        require(accounts[_id].state == accountState.free); // 前提条件是该账号未被占用

        rent memory newRent = rent({
            renterAddress: msg.sender,
            id: _id,
            price: _price,
            rentDays: _rentDays,
            state: rentState.unconfirm,
            beginTime: 0
        });
        rents[_id] = newRent;
        accounts[_id].state = accountState.occupy;
        emit notice(accounts[_id].ownerAddress, "Someone require to rent your account");
    }

    function recive(uint _id) public payable onlyOwner(_id) returns (string) {
        require(rents[_id].state == rentState.unconfirm); // 前提条件是存在该交易

        // 设置密码
        accounts[_id].password = 0;
        if (msg.value < rents[_id].price) {
            emit notice(rents[_id].renterAddress, "Rent failed, you have no enough money to rent");
            return "Sell Failed\n";
        }
        else {
            accounts[_id].ownerAddress.transfer(rents[_id].price);
            rents[_id].state = rentState.confirm;
            rents[_id].beginTime = now;
            // 自动生成密码
            accounts[_id].password = 0;
            emit message(rents[_id].renterAddress, "The password of the account you rent is ", accounts[_id].password);
            return "Sell Success\n";
        }
    }

    function refuse(uint _id) public onlyOwner(_id) {
        require(rents[_id].state == rentState.unconfirm); // 前提条件是存在该账号和该交易

        rents[_id].state = rentState.end;
        accounts[_id].state = accountState.free;
        emit notice(rents[_id].renterAddress, "The owner refuse your rent request ");
    }

    function endRenting(uint _id) public onlyOwner(_id) {
        require(rents[_id].state == rentState.unconfirm || now - rents[_id].beginTime >= rents[_id].rentDays * 86400);

        rents[_id].state = rentState.end;
        // 修改账号状态
        accounts[_id].state = accountState.free;
        // 修改密码
        accounts[_id].password = 1;
    }

    function createAccount(uint _id, uint _password) public {
        require(!validAccounts[_id]);

        account memory newAccount = account({
            ownerAddress: msg.sender,
            id: _id,
            password: _password,
            state: accountState.free
        });
        accounts[_id] = newAccount;
        validAccounts[_id] = true;
    }

    function getRentState(uint _id) public view returns (rentState){
        require(validAccounts[_id]);

        return rents[_id].state;
    }
}