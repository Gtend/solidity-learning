// Solidity Programming
// Token : smart contract based (native token 과는 다름)
// BTC, ETH, XRP, KAIA : native token (transaction 를 처리하기 위해서 해당 네트워크 토큰만 받음)
// pragma 지시어 : solidity compile 시 컴파일러에게 알려주는 내용


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Compile : npx hardhat compile
// 컴파일 시
// -> artifacts/contracts/MyToken.json 
// -> typechain-types

// 배포 : ignition/modules/ 안에 ts 파일 만들기



// CLASS = CONTRACT
contract MyToken {
    // Contract Fields
    string public name; // public으로 선언하면 자동으로 getter 함수 생성
    string public symbol;
    uint8 public decimals; // 1 wei -> 1*10^-18

    uint256 public totalSupply; // 총 발행량
    mapping(address => uint256) public balanceOf; // 누가 몇개 가지고 있는지 : mapping(key, value) 
    
    // 생성자
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    // external : 외부에서 호출 가능
    // view : 읽기 전용 함수 (상태 변경 X)
    // function totalSupply() external view returns (uint256) {
    //     return totalSupply;
    // }

    // function balanceOf(address owner) external view returns (uint256) {
    //     return balanceOf[owner];
    // }

    // function name() external view returns (string memory) {
    //     return name;
    // }

}
