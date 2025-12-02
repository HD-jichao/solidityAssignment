// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./IERC721Metadata.sol";
import "./Strings.sol";

contract ERC721 is IERC721, IERC721Metadata {
    using Strings for uint256;

    string public override name; //token代币名称
    string public override symbol; // token代号

    mapping(uint => address) private _owners; //tokenId是属于哪个账户的 的持有人映射  代币到持有人的映射
    mapping(address => uint) private _balances; //某个账户又有多少tokenId
    mapping(uint => address) private _tokenApprovals; //目前这个tokenId到授权地址的映射
    mapping(address => mapping(address => bool)) private _operatorApprovals; //某个用户是否给另一个用户授权

    // 错误 无效的接收者
    error ERC721InvalidReceiver(address receiver);

    //构造函数，初始化name和symbol
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    // 实现IERC165接口
    function supportsInterface(bytes4 interfaceId) external pure override returns(bool) {
        return 
            interfaceId == type(IERC721).interfaceId || 
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }

    // 实现IERC721的balanceOf,利用_banlances变量查询owner地址的balance. 查询这个用户的balance 有多少个token
    function balanceOf(address owner) external view override returns (uint) {
        require(owner != address(0), "owner == zero address");
        return _balances[owner];
    }

    // 实现IERC721的ownerOf， 利用_owners变量查询tokenId的owner
    function ownerOf(uint tokenId) public view override returns (address owner) {
        owner = _owners[tokenId];
        require(owner != address(0), "token doesn't exist");
    }

    // 实现IERC721的isApprovedForAll 利用_operatorApprovals变量查看owner用户是否将所持有的tokenId批量授权给了 operator
    function isApprovedForAll(address owner, address operator) external view override returns(bool){
        return _operatorApprovals[owner][operator];
    }

    // 实现IERC721的 setApprovalForAll， 将持有的代币全部授权给 operator
    function setApprovalForAll(address operator, bool approved) external override  {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // 实现IERC721的getApproved利用_tokenApprovals变量查询tokenId的授权地址  查询这个账户的某个NFT授权关系
    function getApproved(uint tokenId) external view override returns(address) {
        require(_owners[tokenId] != address(0), "token doesn't exist");
        return _tokenApprovals[tokenId];
    }

    // 授权函数，通过调整_tokenApprovels来授权 to地址操作 tokenId,同时释放Approval事件
    function _approve(address owner,address to, uint tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    // 实现ERC721的Approve函数，将tokenId授权给 to, 条件是 to不能是owner,并且msg.sender是owner或授权地址，调用_approve
    function approve(address to, uint tokenId) external override  {
        address owner = _owners[tokenId];
        require(msg.sender == owner || _operatorApprovals[owner][msg.sender], "not owner nor approved for all");
        _approve(owner, to, tokenId);
    }

    // 查询spender地址是否可以使用 tokenId 需要是 owner或这授权地址
    function _isApprovedOrOwner(address owner, address spender, uint tokenId) private view returns(bool) {
        return (spender == owner || _tokenApprovals[tokenId] == spender || _operatorApprovals[owner][spender]);
    }

    // 转账函数 通过调整_balances和_owner变量将 tokenId从from转账给 to,同时释放 Tranfer事件
    // 条件是 tokenId被发送者(from)拥有 并且 to不是0地址
    function _transfer(address owner, address from, address to, uint tokenId) private {
        require(from == owner, "not owner");
        require(to != address(0), "transfer to the zero address");

        _approve(owner, address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    // 实现IERC721的transferFrom，非安全转账，不建议使用。调用_transfer
    function transferFrom(address from, address to, uint tokenId) external override {
        address owner = ownerOf(tokenId);
        require(_isApprovedOrOwner(owner, msg.sender, tokenId), "not owner nor approved");
        _transfer(owner, from, to, tokenId);
    }

    // 安全转账，安全地将 tokenId代币从from 转移到to, 会检查合约接收者是否了解 ERC721 协议，以防止代币被永久锁定，调用了_transfer函数和_checkOnERC721Received函数
    // 条件： from不能是0地址 & to 不能是0地址 & tokenId代币必须存在，并且被from拥有 & 如果to是智能合约，他必须支持 IERC721Receiver-onERC721Received 
    function _safeTransfer(address owner, address from, address to, uint tokenId, bytes memory _data) private {
        _transfer(owner, from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, _data);
    }

    // 实现ERC721safeTransfer的安全转账，调用__safeTransfer
    function safeTransferFrom(address from, address to, uint tokenId, bytes memory _data) public override {
        address owner = ownerOf(tokenId);
        require(_isApprovedOrOwner(owner, msg.sender, tokenId), "not owner nor approved");
        _safeTransfer(owner, from, to, tokenId, _data);
    }

    // safeTransferFrom重载函数
    function safeTransferFrom(address from, address to, uint tokenId) public override {
        safeTransferFrom(from, to, tokenId, "");
    }

    // 铸造函数， 通过调整 _banlances和 _owners变量铸造 tokenId，并转账给to, 同时释放 Transfer事件
    // 这个mint所有人都能调用，实际使用需要开发人员重写，加上一些条件
    // 条件： tokenId尚不存在 & to不能是0地址
    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0), "mint to zero address");
        require(_owners[tokenId] == address(0), "token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    // 销毁函数， 通过调整_banlances和_owners变量来销毁tokenId, 同时释放Transfer事件，
    // 条件： tokenId存在
    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "not owner of token");

        _approve(owner, address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    // _checkOnERC721Received函数，用于在 to 为合约的时候，调用IERC721Receiver-onERC721Received ，以防 tokenId 被不小心转进黑洞
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                if (retval != IERC721Receiver.onERC721Received.selector) {
                    revert ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if(reason.length == 0) {
                    revert ERC721InvalidReceiver(to);
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    }

    // 实现IERC721Metadata的tokenURI函数，查询metadata
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_owners[tokenId] != address(0), "Token Not Exist");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    // 计算 tokenURI的BaseURI, tokenURI就是把baseURI和tokenId拼凑在一起，需要开发重写。
    // BAYC的baseURI为ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

}