// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Appstorage{
    mapping(address => uint256)  ERC20balances;

    mapping(address => mapping(address => uint256))  ERC20allowances;

    uint256  ERC20totalSupply;

    string  ERC20name;
    string  ERC20symbol;

    /////////////////////////////////////////////////ERC721////////////////////////////////////////////////////////
    
    string  ERC721name;

    // Token symbol
    
    string  ERC721symbol;

    // Mapping from token ID to owner address
    
    mapping(uint256 => address)  ERC721owners;

    // Mapping owner address to token count
    mapping(address => uint256)  ERC721balances;

    // Mapping from token ID to approved address
    
    mapping(uint256 => address)  ERC721tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool))  ERC721operatorApprovals;
}


library slot{
    function appStorage() internal pure returns(Appstorage storage s) {    
        assembly { s.slot := 0 }
    }
}
