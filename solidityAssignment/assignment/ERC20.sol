// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20{
    mapping (address => uint256) public override balanceOf; //某个用户的代币总和对应情况  //自动形成getter函数 对应IERC20中的函数

    mapping (address => mapping (address => uint256)) public override allowance; //某个用户的授权情况 //自动形成getter函数 对应IERC20中的函数

    uint256 public override totalSupply; //代币总供给  //自动形成getter函数 对应IERC20中的函数

    string public name; //名称
    string public symbol; //代号

    uint8 public decimals = 18; //小数位数
    
    constructor (string memory name_, string memory symbol_) { //启动合约自动执行 初始化构造函数(记录当前调用的 代币名称、代币代号)
        name = name_;
        symbol = symbol_;
    }

    function transfer(address recipient, uint amount) public override returns(bool) { //转账函数， 接收者、要转多少代币
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    function approve(address spender, uint amount) public override returns(bool) { //授权函数， 接受授权者、要授权多少代币
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint amount) public override returns(bool) { //授权转账函数， 授权者、接收者、要赚多少代币
        allowance[sender][msg.sender] -= amount; //授权者、被授权者(执行函数的用户)
        balanceOf[sender] -=amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
        
    }
    function burn(uint amount) external  {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

