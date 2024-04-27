// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {WETH} from "../../src/tutorial Invariant testing/WETH.sol";

contract WETHTest is Test {
    WETH maincontract;

    function setUp() public {
        maincontract = new WETH();
    }

    function invariant_TotalSupplyIsAlwaysZero() public view {
        assertEq(maincontract.totalSupply(), 0);
    }
}
