// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeggingContract {
    address public owner;
    mapping (address => uint) public donations;

    address[3] public topThree;

    event DonationLog(address indexed spender, uint indexed donationNum);
    event Withdrawn(address indexed spender, uint indexed donationNum);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    constructor() {
        owner = msg.sender;
    }

    // 捐赠函数，接收 ETH 并更新记录
    function donate() public payable {
        require(msg.value > 0, "No ETH send");
        donations[msg.sender] += msg.value;
        _updateTopThree(msg.sender);
        emit DonationLog(msg.sender, msg.value);
    }

    // 允许所有者提取所有合约（使用安全一些的call）
    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "no balance");

        (bool ok, ) = payable(owner).call{value: amount}("");
        require(ok, "Withdraw failed");

        emit Withdrawn(owner, amount);
    }

    // 查询某个地址累计捐赠多少ETH
    function getDonation(address donor) external view returns (uint256) {
        return donations[donor];
    }

    // 返回前三名捐赠者
    function getTopDonors() external view returns (address[3] memory) {
        return topThree;
    }

    // 更新前三名 捐赠列表
    function _updateTopThree(address donor) internal {
        uint256 donorAmount = donations[donor];
        for(uint256 i = 0; i < 3; i++) {
            address top = topThree[i];
            uint256 topAmount = donations[top];

            // 如果这个人应该排在更前面，则插入
            if(donorAmount > topAmount) {
                // 从 i 处往后移动
                for(uint256 j = 2; j > i; j--) {
                    topThree[j] = topThree[j-1];
                }
                topThree[i] = donor;
                break;
            }
        }
    }

    // 接收 ETH 的fallback / receive
    receive() external payable {
        donate();
    }
}