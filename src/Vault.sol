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
        require(shares > 0);
        totalSupply += shares;
        balanceOf[to] += shares;
    }

    /**
     * function responsible for burning shares of tokens
     * @param from address to burn shares from
     * @param shares amount of shares to burn from
     */
    function burn(address from, uint shares) internal {
        require(shares > 0);
        totalSupply -= shares;
        balanceOf[from] -= shares;
    }

    function convertShares(
        uint256 amount
    ) private view returns (uint256 shares) {
        shares = (amount * totalSupply) / token.balanceOf(address(this));
        return shares;
    }

    function convertAssets(
        uint256 shares
    ) private view returns (uint256 amountAssets) {
        amountAssets = (shares * token.balanceOf(address(this))) / totalSupply;
        return amountAssets;
    }

    function Deposit(uint256 amount) public {
        require(amount > 0);
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B 

        s = aT / B
        */
        uint256 shares;
        shares = convertShares(amount);
        mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), amount);
    }

    function Withdraw(uint256 shares) public returns (uint256) {
        require(shares > 0);
        require(shares <= balanceOf[msg.sender]);

        uint256 amount = convertAssets(shares);

        burn(msg.sender, amount);
        token.transferFrom(address(this), msg.sender, amount);
        //returns amount burnt or sent to receiver
        return amount;
    }
}
