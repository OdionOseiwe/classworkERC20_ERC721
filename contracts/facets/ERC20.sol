// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IERC20} from "../interfaces/IERC20.sol";



import {Appstorage} from "../libraries/Appstorage.sol";


contract ERC20 is IERC20{

    Appstorage internal s;

    // constructor(string memory name_, string memory symbol_) {
    //     _name = name_;
    //     _symbol = symbol_;
    // }

    function name() public     returns (string memory) {
        return s.ERC20name = "Na";
    }

    function symbol() public    returns (string memory) {
        return s.ERC20symbol = "N";
    }

    function decimals() public view    returns (uint8) {
        return 18;
    }

    function totalSupply() public view  override  returns (uint256) {
        return s.ERC20totalSupply;
    }

    function balanceOf(address account) public view  override  returns (uint256) {
        return s.ERC20balances[account];
    }

    function transfer(address to, uint256 amount) public  override  returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }


    function allowance(address owner, address spender) public view  override returns (uint256) {
        return s.ERC20allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public  override returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public   override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public   returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }
    function _transfer(
        address from,
        address to,
        uint256 amount
    )   internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = s.ERC20balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            s.ERC20balances[from] = fromBalance - amount;
        }
        s.ERC20balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal   {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        s.ERC20totalSupply += amount;
        s.ERC20balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal  {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = s.ERC20balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            s.ERC20balances[account] = accountBalance - amount;
        }
        s.ERC20totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        s.ERC20allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal   {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

  
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal  {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal  {}
}
