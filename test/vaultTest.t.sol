// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Vault2} from "../src/Vault.sol";
import {FourbToken} from "../src/ERC20.sol";

contract VaultTest is Test {
    Vault2 public vault;
    FourbToken token;
    address userOne = makeAddr("firstuser");

    function setUp() public {
        token = new FourbToken("BBBBTOKEN", "4BTKN", 8, 120e8);
        // deployed with custom token
        vault = new Vault2(address(token), 1e8);
        // this contract is supposed to be deployed with stake holders deposit to moderate the vault
        vm.prank(address(vault));
        token.mint(1e8);

        address userTwo = makeAddr("secondUSER");
        vm.startPrank(userTwo);
        token.mint(30e7);
        token.approve(15e7, address(vault));
        vm.stopPrank();
    }

    function test_vaultDeposit() public {
        vm.startPrank(msg.sender);
        token.mint(10e8);
        token.approve(7e8, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);
        console2.log(
            "Allowance: ",
            token.Allowance(
                msg.sender,
                0x2e234DAe75C793f67A35089C9d99245E1C58470b
            )
        );
        vault.deposit(5e8);
        console2.log(
            "Allowance: ",
            token.Allowance(
                msg.sender,
                0x2e234DAe75C793f67A35089C9d99245E1C58470b
            )
        );
        console2.log("msg.sender balance", token.balanceOf(msg.sender));
        // console2.log("userOne balance is ", token.balanceOf(userOne));
        // console2.log(address(msg.sender));
        // console2.log(address(userOne));
        // console2.log(address(this));
        // console2.log(address(vault));
        // console2.log(address(token));

        vm.stopPrank();

        assertEq(token.balanceOf(msg.sender), 5e8);
        assertGt(vault.balanceOf(msg.sender), 0);
    }
}
