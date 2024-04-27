// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {WETH} from "../../src/tutorial Invariant testing/WETH.sol";
import {HandlerWETH} from "./HandlerBsdTsting.t.sol";

import {CommonBase} from "forge-std/Base.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract ActorManager is CommonBase, StdCheats, StdUtils {
    HandlerWETH[] public handlers;

    constructor(HandlerWETH[] memory _handlers) {
        handlers = _handlers;
    }

    function sendToFallback(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].sendToFallback(amount);
    }

    function deposit(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].deposit(amount);
    }

    function withdraw(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].withdraw(amount);
    }
}

contract WETH_Multi_Handler_Invariant_Tests is Test {
    WETH public weth;
    ActorManager public manager;
    HandlerWETH[] public handlers;

    function setUp() public {
        weth = new WETH();

        for (uint i = 0; i < 3; i++) {
            handlers.push(new HandlerWETH(weth));

            deal(address(handlers[i]), 100e18);
        }

        manager = new ActorManager(handlers);
        targetContract(address(manager));
    }

    function invariant_eth_balance1() public view {
        uint256 total = 0;
        for (uint i = 0; i < handlers.length - 1; i++) {
            total += handlers[i].wethBalance();
        }
        console2.log("ETH total: ", total / 1e18);
        assertGe(address(weth).balance, total);
    }
}
