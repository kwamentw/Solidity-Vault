// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {WETH} from "../../src/tutorial/WETH.sol";
import {HandlerWETH} from "./HandlerBsdTsting.t.sol";

contract WethTesting is Test {
    WETH public weth;
    HandlerWETH public handler;

    function setUp() public {
        weth = new WETH();
        handler = new HandlerWETH(weth);

        deal(address(handler), 100e18);
        targetContract(address(handler));

        bytes4[] memory selectorsM = new bytes4[](3);
        selectorsM[0] = handler.deposit.selector;
        selectorsM[1] = handler.withdraw.selector;
        selectorsM[2] = handler.sendToFallback.selector;

        targetSelector(
            FuzzSelector({addr: address(handler), selectors: selectorsM})
        );
    }

    function invariant_eth_balance() public view {
        assertGe(address(weth).balance, handler.wethBalance());
    }
}
