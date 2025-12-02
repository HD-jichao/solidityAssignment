// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 查询代币总和
    function totalSupply() external view returns (uint256);
    // 查询账户还有多少代币
    function balanceOf(address account) external view returns (uint256);
    // 给to转账amount个代币 成功之后返回true, 同时调用 Transfer事件
    function transfer(address to, uint256 amount) external returns (bool);
    // 查询当前授权情况 owner给spender授权了多少
    function allowance(address owner, address spender) external view returns (uint256);
    // 调用者给spender授权 amount 个代币 成功返回true
    function approve(address spender, uint256 amount) external returns(bool);
    // 授权转账，通过授权机制from向to进行转账，转账部分会从调用者的allowance扣除，成功返回true
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}