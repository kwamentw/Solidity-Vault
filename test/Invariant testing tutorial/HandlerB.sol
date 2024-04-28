// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {WETH} from "../../src/tutorial Invariant testing/WETH.sol";

import {CommonBase} from "forge-std/Base.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract HandlerWETH is CommonBase, StdCheats, StdUtils {
    WETH private weth;
    uint256 public wethBalance;

    constructor(WETH _weth) {
        weth = _weth;
    }

    receive() external payable {}

    function sendToFallback(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        (bool sent, ) = address(weth).call{value: amount}("");
        require(sent, "sendToFallback failed");
    }

    function deposit(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        weth.deposit{value: amount}();
    }

    function withdraw(uint256 amount) public {
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        wethBalance -= amount;
        weth.withdraw(amount);
    }

    function fail() public pure {
        revert("failed");
    }
}
