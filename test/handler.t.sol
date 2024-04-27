// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {StdInvariant} from "forge-std/StdInvariant.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {Vault} from "../src/Vault.sol";
import {FourbToken} from "../src/ERC20.sol";

contract Vaulthandler is CommonBase, StdUtils {
    Vault vault1;

    uint256 public totSupp;

    uint256 public totSuppPrev;

    FourbToken token;

    address[] public senders;
    address internal currentSender;

    uint256 public balbefore;
    uint256 public balafter;
    uint256 public totalSupplyfuzz;
    uint256 public totalSupplyfuzzPrev;
    bool public isMinted;

    // You can use this too for actors

    // modifier useActor(uint256 actorIndexSeed) {
    //     currentSender = senders[bound(actorIndexSeed, 0, senders.length)];
    //     vm.startPrank(currentSender);
    //     _;
    //     vm.stopPrank();
    // }

    constructor(Vault maincontract) {
        vault1 = maincontract;
    }

    function _mint(uint amount) public {
        amount = bound(amount, 1, 1000000000e6);
        if (amount == 0) return;
        vm.startPrank(msg.sender);
        totSuppPrev = vault1.getTotalSupply();
        isMinted = token.mint(amount);
        totSupp = vault1.getTotalSupply();
        vm.stopPrank();
    }

    function Deposit(uint256 addressSeed, uint fuxxAmount) public {
        currentSender = senders[bound(addressSeed, 0, senders.length - 1)];
        fuxxAmount = bound(fuxxAmount, 1e6, type(uint256).max);

        if (fuxxAmount == 0) return;

        vm.startPrank(currentSender);

        token.mint(fuxxAmount);

        //approve vault
        token.approve(fuxxAmount, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);

        totalSupplyfuzzPrev = vault1.getTotalSupply();
        balbefore = token.balanceOf(currentSender);

        vault1.Deposit(fuxxAmount);

        balafter = token.balanceOf(currentSender);
        totalSupplyfuzz = vault1.getTotalSupply();

        vm.stopPrank();
    }
}
