// Solidity Programming
// Token : smart contract based (native token 과는 다름)
// BTC, ETH, XRP, KAIA : native token (transaction 를 처리하기 위해서 해당 네트워크 토큰만 받음)
// pragma 지시어 : solidity compile 시 컴파일러에게 알려주는 내용


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./ManagedAccess.sol";
// Compile : npx hardhat compile
// 컴파일 시
// -> artifacts/contracts/MyToken.json 
// -> typechain-types

// 배포 : ignition/modules/ 안에 ts 파일 만들기



// CLASS = CONTRACT
contract MyToken is ManagedAccess {
    // Event : history를 storage에 모두 저장하면 비용이 많이 듬 -> receipt에 내보냄
    event Transfer(address indexed from, address indexed to, uint256 value); // String (Hash)-> Topic
    event Approval(address indexed spender, uint256 amount);
    // Contract Fields

    string public name; // public으로 선언하면 자동으로 getter 함수 생성
    string public symbol;
    uint8 public decimals; // 1 wei -> 1*10^-18

    uint256 public totalSupply; // 총 발행량
    mapping(address => uint256) public balanceOf; // 누가 몇개 가지고 있는지 : mapping(key, value) 
    
    // approve
    mapping(address => mapping(address => uint256)) public allowance;

    // 탈 중앙화, 데이터의 무결성
    // 데이터를 조회하는것은 어떤 노드(블록체인의 노드는 모두 동일 데이터 갖고 있음)에 조회해도 동일한 값을 리턴해줌 = Transaction을 만들 필요 없음

    // 배포 = Transaction) -> gas(transaction 수수료) 비용 발생
    // transfer 호출 =  transaction -> gas(transaction 수수료) 비용 발생
    // 단순 view 함수 호출 = Just API Call -> gas(transaction 수수료) 비용 없음

    // 생성자
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _amount) ManagedAccess(msg.sender, msg.sender) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
         // msg.sender(배포자) 에게 토큰 발행
        _mint(_amount*10**uint256(decimals), msg.sender); // 1 MT
        // transaction 시 from에 해당하는 주소 : msg.sender
    }

    // approve : amount 만큼 spender가 내 토큰을 쓸 수 있도록 허락
    function approve(address spender, uint256 amount) external {
        allowance[msg.sender][spender] = amount;
        emit Approval(spender, amount);
    }

    // transferFrom : spender가 owner의 토큰을 to에게 amount 만큼 전송
    function transferFrom(address from, address to, uint256 amount) external {
        address spender = msg.sender;
        require(allowance[from][spender] >= amount, "insufficient allowance");
        allowance[from][spender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    function mint(uint256 amount, address to) external onlyManager{
       _mint(amount, to);
    }

    function setManager(address _manager) external onlyOwner {
        manager = _manager;
    }

    // mint : 토큰 발행 -> internal로 내부에서만 호출 가능
    function _mint(uint256 amount, address to) internal {
       totalSupply += amount;
       balanceOf[to] += amount;

       emit Transfer(address(0), to, amount);
    }

    // transfer : 토큰 전송
    function transfer(uint256 amount, address to) external {
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function faucet(uint256 amount) external {

    _mint(amount, msg.sender);

    }



    // Getter 함수
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

/*
approve 
- allow spender address to send my token : 다른 사람이 내 토큰을 보낼 수 있도록
transferFrom
- spender: owner -> target address : spender가 transfer (Spender가 owner의 토큰을 target에게 보냄)

* token owner --> bank
* token owner --> router contract --> bank contract
* token owner --> router contract --> bank contract (multi contract)

*/