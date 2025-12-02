// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool appoved);

    // 返回传入地址的NFT持有量 
    function balanceOf(address owner) external view returns (uint256 balance);

    // 返回某个tokenId(NFT的ID)的主人（持有者）
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // 安全转账(如果接收方是合约地址，会要求实现ERC721Receiver接口) 参数为 转出的地址：from,接收地址to,tokenId(NFT的Id) 
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    // 安全转账(如果接收方是合约地址，会要求实现ERC721Receiver接口) 参数为 转出的地址：from,接收地址to,tokenId(NFT的Id) 
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    // 普通转帐，from：转出地址，to: 接收地址
    function transferFrom(address from,address to,uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function setApprovalForAll(address operator, bool _approved) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    
}