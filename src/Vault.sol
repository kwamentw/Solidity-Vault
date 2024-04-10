// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract Vault {
    // token that the vault uses
    IERC20 immutable token;

    // total number of vault tokens minted
    uint256 totalSupply;
    // balance of addresses that got vault tokens
    mapping(address => uint256) balanceOf;

    constructor(address _token) {
        // initializing the token we want to use as vault tokens
        token = IERC20(_token);
        //there should always be an initial deposit before using this contract
        uint256 initialSupply = 1000;
        totalSupply = initialSupply;
    }

    /**
     * function to mint shares of token to address
     * @param to address receiving minted shares
     * @param shares amount of shares
     */
    function mint(address to, uint256 shares) internal {
        totalSupply += shares;
        balanceOf[to] += shares;
    }

    /**
     * function responsible for burning shares of tokens
     * @param from address to burn shares from
     * @param shares amount of shares to burn from
     */
    function burn(address from, uint shares) internal {
        totalSupply -= shares;
        balanceOf[from] -= shares;
    }

    function Deposit(uint256 amount) public {
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B 

        s = aT / B
        */
        uint256 shares;
        shares = (amount * totalSupply) / token.balanceOf(address(this));
        mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), amount);
    }

    function Withdraw(uint256 shares) public returns (uint256) {
        /*
        a = amount
        B = balance of token before withdraw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B 

        a = sB / T
        */
        uint256 amount = (shares * token.balanceOf(address(this))) /
            totalSupply;

        burn(msg.sender, amount);
        token.transferFrom(address(this), msg.sender, amount);
        //returns amount burnt or sent to receiver
        return amount;
    }
}
