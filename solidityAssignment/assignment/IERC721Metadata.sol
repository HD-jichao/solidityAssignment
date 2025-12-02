// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";

interface IERC721Metadata is IERC721 {

    // 返回代币名称
    function name() external view returns(string memory);

    // 返回代币代号
    function symbol() external view returns(string memory);

    // 通过tokenId查询metadata链接的url,ERC721特有函数
    function tokenURI(uint256 tokenId) external view returns(string memory); 
}