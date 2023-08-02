// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./IERC20.sol";

contract Obamna is IERC20 {

    modifier onlyOwner {
        require(_owner == msg.sender, "You are not owner! SODAAA!!!");
        _;
    }

    modifier enoughBalance(address _from, uint amount) {
        require(balances[_from] >= amount, "Not enough balance! SODAAA!!!");
        _;
    }

    address _owner;
    uint _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;

    constructor() {
        _owner = msg.sender;
        mint(1000 * 10**18); // Mints 1000 initial tokens
    }

    function name() external view returns(string memory) {
        return "Obamna token";
    }
    
    function symbol() external view returns(string memory) {
        return "OBAMNA";
    }

    function decimals() external pure returns(uint) {
        return 18;
    }

    function totalSupply() external view returns(uint) {
        return _totalSupply;
    }
    
    function balanceOf(address account) external view returns(uint) {
        return balances[account];
    }
    
    function transfer(address _to, uint amount) enoughBalance(msg.sender, amount) external {
        balances[msg.sender] -= amount;
        balances[_to] += amount;
        emit Transfer(msg.sender, _to, amount);
    }
    
    function allowance(address owner, address spender) external view returns(uint) {
        return allowances[owner][spender];
    }
    
    function approve(address spender, uint amount) external {
        allowances[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) enoughBalance(sender, amount) external {
        require(allowances[sender][recipient] >= amount, "Not enough allowances!!! SODAAA!");
        allowances[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    // Mints new tokens and adds them to owner's balance
    function mint(uint amount) public onlyOwner {
        _totalSupply += amount;
        balances[_owner] += amount;
        emit Transfer(address(0), _owner, amount);
    }

}