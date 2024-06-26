// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

////////////////////////////////////
//--------vault 1-----------------//
////////////////////////////////////

import {IERC20} from "./interface/IERC20.sol";
import {Math} from "../lib/Math.sol";

//logic-amount of tokens sent-calc shares to minted upon amount sent-shares minted to user-totalsupplyincreases

// Amount/Assets/AmountAssets all refer to the amount of the tokens used in making txns in this vault
// whenever we want real to deposit or withdraw it is in this currency// i don't know why i find this hard to assimilate

contract Vault {
    using Math for uint256;

    event DepositAsset(address user, uint256 amountAssets);
    event WithdrawAsset(address user, uint256 amountAsset);
    event Minted(address to, uint256 amount);
    event Burned(address fromwhich, uint256 shares);
    // token that the vault uses
    IERC20 immutable token;

    // total number of vault tokens minted
    uint256 public totalSupply;
    // balance of addresses that got vault tokens
    mapping(address => uint256) public balanceOf;

    constructor(address _token, uint256 initialSupply) {
        // initializing the token we want to use as vault tokens
        token = IERC20(_token);
        //there should always be an initial deposit before using this contract
        totalSupply = initialSupply;
    }

    /**
     * This is a function to get the price(USD equivalent) of the underlying asset
     */
    // function getPrice(address _token) public view returns (uint256) {
    //     // if we are going to use DAI, the decimal precision is 18
    //     AggregatorV3Interface pricefeed = AggregatorV3Interface(_token);
    //     (, int price, , , ) = pricefeed.latestRoundData();
    //     return uint256(price);
    // }

    /**
     *  to mint shares of token to address
     * @param to address receiving minted shares
     * @param shares amount of shares
     */
    function _mint(address to, uint256 shares) internal {
        emit Minted(to, shares);
        require(shares > 0, "revert shares");
        totalSupply += shares;
        balanceOf[to] += shares;
    }

    /**
     *  responsible for burning shares of tokens
     * @param from address to burn shares from
     * @param shares amount of shares to burn from
     */
    function _burn(address from, uint shares) internal {
        require(shares > 0);
        emit Burned(from, shares);
        totalSupply -= shares;
        balanceOf[from] -= shares;
    }

    /**
     * converts some amount ot token to shares
     * @param amount amount of underlying token/asset you want to convert to shares
     */
    function convertShares(
        uint256 amount
    ) internal view returns (uint256 shares) {
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B

        s = aT / B
        */
        // shares = (amount * totalSupply) / token.balanceOf(address(this));
        shares = Math.mulDiv(
            amount,
            totalSupply,
            token.balanceOf(address(this))
        );
        return shares;
    }

    /**
     * converts shares to assets
     * @param shares number of shares you want to convert to underlying token/asset
     */
    function convertAssets(
        uint256 shares
    ) public view returns (uint256 amountAssets) {
        /*
        a = amount
        B = balance of token before withdraw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B

        a = sB / T
        */
        // amountAssets =
        //     ((shares * token.balanceOf(address(this))) * 1e8) /
        //     totalSupply;
        amountAssets = Math.mulDiv(
            shares,
            token.balanceOf(address(this)),
            totalSupply,
            Math.Rounding.Ceil
        );
        return amountAssets;
    }

    /**
     *A function to deposit assets or amount of some tokens into the vault
     * @param amount amount of tokens you want to deposit in the vault
     */
    function Deposit(uint256 amount) public {
        require(amount > 0, "revert1");
        uint256 shares;
        shares = convertShares(amount);
        emit DepositAsset(msg.sender, amount);
        _mint(msg.sender, shares);
        token.transferfrom(msg.sender, address(this), amount);
    }

    /**
     *  to withdraw you shares in the vault
     * @param shares number of shares you withdrawing
     */
    function Withdraw(uint256 shares) external {
        require(shares > 0, "withdraw error 1");

        uint256 amount = convertAssets(shares);

        emit WithdrawAsset(msg.sender, shares);
        _burn(msg.sender, shares);

        token.TransferToken(msg.sender, amount);
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply;
    }

    function getBalanceOf(address account) external view returns (uint256) {
        return balanceOf[account];
    }
}

// -----------vault 2---------------//

contract Vault2 {
    IERC20 public immutable token;

    // there should initial shares minted
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(address _token, uint256 _initialdeposit) {
        token = IERC20(_token);
        // this is done by the owners of the vault to regulate minting
        totalSupply += _initialdeposit;
    }

    function getAsset() public view returns (IERC20) {
        return token;
    }

    function _mint(address _to, uint256 _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint256 _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function deposit(uint256 amount) external {
        uint256 shares = (amount * totalSupply) /
            token.balanceOf(address(this));
        _mint(msg.sender, shares);
        token.transferfrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 shares) external {
        uint256 amount = (shares * token.balanceOf(address(this))) /
            totalSupply;
        _burn(msg.sender, shares);
        token.TransferToken(msg.sender, amount);
    }
}
