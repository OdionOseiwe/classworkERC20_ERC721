

pragma solidity ^0.8.0;

import {IERC721} from "../interfaces/IERC721.sol";

import {Appstorage} from "../libraries/Appstorage.sol";
import {IERC165} from "../interfaces/IERC165.sol";

contract ERC721 is IERC721{
    Appstorage internal s;

    function balanceOf(address owner) public view  override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return s.ERC721balances[owner];
    }

    function ownerOf(uint256 tokenId) public view override  returns (address) {
        address owner = s.ERC721owners[tokenId];
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function name() public view  returns (string memory) {
        return s.ERC721name;
    }


    function symbol() public view  returns (string memory) {
        return s.ERC721symbol;
    }

    function tokenURI(uint256 tokenId) public view virtual  returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI)) : "";
    }

    function _baseURI() internal view  returns (string memory) {
        return "";
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not token owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return s.ERC721tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public override  {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view override  returns (bool) {
        return s.ERC721operatorApprovals[owner][operator];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
   
    ) public      override  {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: caller is not token owner nor approved");

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public  override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override  {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: caller is not token owner nor approved");
        _safeTransfer(from, to, tokenId, data);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transfer(from, to, tokenId);
       
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return s.ERC721owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        s.ERC721balances[to] += 1;
        s.ERC721owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        s.ERC721balances[owner] -= 1;
        delete s.ERC721owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        s.ERC721balances[from] -= 1;
        s.ERC721balances[to] += 1;
        s.ERC721owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        s.ERC721tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        s.ERC721operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    // function _checkOnERC721Received(
    //     address from,
    //     address to,
    //     uint256 tokenId,
    //     bytes memory data
    // ) private returns (bool) {
    //     if (to.isContract()) {
    //         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
    //             return retval == IERC721Receiver.onERC721Received.selector;
    //         } catch (bytes memory reason) {
    //             if (reason.length == 0) {
    //                 revert("ERC721: transfer to non ERC721Receiver implementer");
    //             } else {
    //                 /// @solidity memory-safe-assembly
    //                 assembly {
    //                     revert(add(32, reason), mload(reason))
    //                 }
    //             }
    //         }
    //     } else {
    //         return true;
    //     }
    // }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

     //function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

