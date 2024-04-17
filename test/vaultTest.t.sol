// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {Math} from "../lib/Math.sol";

contract VaultTest is Test {
    Vault vault;

    function setUp() public {
        // deploy with DAi for now
        vault = new Vault(0x14866185B1962B63C3Ea9E03Bc1da838bab34C19);
    }

    /**
     * Testing whether the price feed is working
     */
    function testPriceFeedDAI() public {
        address token = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;
        uint256 currentPrice = vault.getPrice(token);
        uint256 defaultPrice;
        assertGt(currentPrice, defaultPrice);
        console2.log(
            "Current price of DAI is ",
            // every ETH pair has 18 decimals and non eth pairs have 8
            Math.ceilDiv(currentPrice, 1e8)
        );
    }

    function testDepositVault() public {
        // before deposit
        uint256 beforeBal = vault.getBalanceOf(msg.sender);
        uint256 prevToSupp = vault.getTotalSupply();

        hoax(address(this), 99e9);
        vault.Deposit(55e8);

        uint256 afterBal = vault.getBalanceOf(msg.sender);
        uint256 afterToSupp = vault.getTotalSupply();

        console2.log("Before----");
        console2.log(beforeBal, prevToSupp);
        console2.log("After--------");
        console2.log(afterBal, afterToSupp);
    }
}
