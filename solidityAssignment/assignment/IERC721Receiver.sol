// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Receiver {
    // 防止误转入没有实现ERC721的合约， 对应safeTranferFrom(安全转账) 也就是目标合约必须实现这个接口，通过安全转账接受ERC721
    function onERC721Received(address operator, address from, uint tokenId, bytes calldata data) external returns(bytes4);
}