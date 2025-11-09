// Banking Service Smart Contract
// MyToken을 예치 후 출금하는 서비스
// staking 
// deposit (예금) / withdraw (출금)

// MyToken : token balance management
//  - the balance of TinyBank address
// TinyBank : deposit / withdraw vault
//  - users token management
//  - user --> deposit --> TinyBank --> transfer(user --> TinyBank)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IMyToken {
    function transfer(address to, uint256 amount) external;
    function transferFrom(address from,  address to, uint256 amount) external;
}

contract TinyBank {
    event Staked(address, uint256);
    IMyToken public stakingToken;
    mapping(address => uint256) public staked;
    uint256 public totalStaked;

    constructor(IMyToken _stakingToken) {
        stakingToken = _stakingToken;
    }

    function stake(uint256 _amount) external {
        require(_amount >= 0, "cannot stake 0 amount");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        staked[msg.sender] += _amount;
        totalStaked += _amount;
        emit Staked(msg.sender, _amount);
    }
}

