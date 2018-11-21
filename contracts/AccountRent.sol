pragma solidity ^0.4.24;

contract AccountRent {
    enum accountState {free, occupy}
    enum rentState {unconfirm, confirm, renting, end}

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

    event notice(address _to, string _message, uint);

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

    function RentRequire(uint _id, uint _rentDays) public {
        require(accounts[_id].state == accountState.free); // 前提条件是该账号未被占用

        rent memory newRent = rent({
            renterAddress: msg.sender,
            id: _id,
            price: 0,
            rentDays: _rentDays,
            state: rentState.unconfirm,
            beginTime: 0
        });
        accounts[_id].state = accountState.occupy;
        rents[_id] = newRent;
        emit notice(accounts[_id].ownerAddress, "Someone require to rent your account ", _id);
    }

    function OwnerConfirm(uint _id) public onlyOwner(_id) {
        require(rents[_id].state == rentState.unconfirm); // 前提条件是存在该交易

        rents[_id].state = rentState.confirm;
        // 设置密码
        accounts[_id].password = 0;
        emit notice(rents[_id].renterAddress, "The owner agree you to rent, the price is ", rents[_id].price);
    }

    function OwnerRefuse(uint _id) public onlyOwner(_id) {
        require(validAccounts[_id] && rents[_id].state == rentState.unconfirm); // 前提条件是存在该账号和该交易

        rents[_id].state = rentState.end;
        accounts[_id].state = accountState.free;
        emit notice(rents[_id].renterAddress, "The owner refuse you to rent account ", _id);
    }

    function StartRenting(uint _id) public payable onlyRenter(_id) {
        require(validAccounts[_id] && rents[_id].state == rentState.confirm); // 前提条件是存在该账号和该交易

        if (msg.value < rents[_id].price) {
            emit notice(rents[_id].renterAddress, "Rent failed, you have no enough money to rent account ", _id);
        }
        else {
            accounts[_id].ownerAddress.transfer(rents[_id].price);
            rents[_id].state = rentState.renting;
            rents[_id].beginTime = now;
            emit notice(rents[_id].renterAddress, "The password of the account you rent is ", accounts[_id].password);
        }
    }

    function EndRenting(uint _id) public onlyOwner(_id) {
        require(now - rents[_id].beginTime >= rents[_id].rentDays);

        rents[_id].state = rentState.end;
        // 修改账号状态
        accounts[_id].state = accountState.free;
        // 修改密码
        accounts[_id].password = 1;
    }

    function UploadAccount(uint _id, uint _password) public {
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
}