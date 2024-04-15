// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    Vault vault;

    function setUp() public {
        // deploy with DAi for now
        vault = new Vault(0x14866185B1962B63C3Ea9E03Bc1da838bab34C19);
    }
}
