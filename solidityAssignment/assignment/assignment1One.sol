// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/*
创建一个名为Voting的合约，包含以下功能：
一个mapping来存储候选人的得票数
一个vote函数，允许用户投票给某个候选人
一个getVotes函数，返回某个候选人的得票数
一个resetVotes函数，重置所有候选人的得票数
*/

contract Voting {
    // 定义候选人结构体，用于存储候选人信息
    struct Candidate {
        string name;    // 候选人的名字
        uint voteCount; // 候选人的得票数
    }

    // mapping 用来存储每个候选人地址和候选人信息
    mapping(address => Candidate) public candidates;
    
    // 存储所有候选人地址的数组
    address[] public candidateAddresses;

    // 事件：当有人投票时会触发，记录投票者和候选人地址
    event Voted(address indexed voter, address indexed candidate);

    // 投票函数，允许用户为指定的候选人投票
    function vote(address candidateAddress) public {
        // 检查候选人是否存在
        require(bytes(candidates[candidateAddress].name).length != 0, "Candidate does not exist.");
        
        // 增加候选人的得票数
        candidates[candidateAddress].voteCount++;
        
        // 触发 Voted 事件，记录投票者和被投票的候选人
        emit Voted(msg.sender, candidateAddress);
    }

    // 获取指定候选人的得票数
    function getVotes(address candidateAddress) public view returns (uint) {
        // 检查候选人是否存在
        require(bytes(candidates[candidateAddress].name).length != 0, "Candidate does not exist.");
        
        // 返回该候选人的得票数
        return candidates[candidateAddress].voteCount;
    }

    // 重置所有候选人的得票数
    function resetVotes() public {
        // 遍历所有候选人地址，并将他们的得票数重置为0
        for (uint i = 0; i < candidateAddresses.length; i++) {
            address candidateAddress = candidateAddresses[i];
            candidates[candidateAddress].voteCount = 0;
        }
    }

    // 添加新的候选人，传入候选人地址和名字
    function addCandidate(address candidateAddress, string memory name) public {
        // 检查候选人是否已存在
        require(bytes(candidates[candidateAddress].name).length == 0, "Candidate already exists.");
        
        // 添加新候选人，并初始化得票数为 0
        candidates[candidateAddress] = Candidate(name, 0);
        
        // 将候选人地址添加到候选人地址数组中
        candidateAddresses.push(candidateAddress);
    }
}
