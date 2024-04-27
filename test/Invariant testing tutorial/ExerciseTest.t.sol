// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Exercise} from "../../src/tutorial Invariant testing/tutorial.sol";
import {Test} from "forge-std/Test.sol";

contract ExerciseTest is Test {
    Exercise maincontract;

    function setUp() public {
        maincontract = new Exercise();
    }

    function invariant_FlagIsAlwaysFalse() public view {
        assertEq(maincontract.flag(), false);
    }
}
