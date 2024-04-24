// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

// import statements
import {Test, console2} from "forge-std/Test.sol";
// import {Vault2} from "../src/Vault.sol";
import {Vault} from "../src/Vault.sol";
import {FourbToken} from "../src/ERC20.sol";

contract VaultTest1 is Test {
    // vault1 initialisation
    Vault vault1;

    //underlying token
    FourbToken token;

    // Depositiors Address
    address firstUser = makeAddr("FIRSTUSER");
    address secondUser = makeAddr("SECONDUSER");

    function setUp() public {
        // initialising underlying token
        token = new FourbToken("FBTKN", "BBBBTKN", 6, 10);
        // initialising vault in use
        vault1 = new Vault(address(token), 40e6);

        // minting some tokens to the vault to prevent vault inflation attacks
        vm.prank(0x2e234DAe75C793f67A35089C9d99245E1C58470b);
        token.mint(40e6);
    }

    /**
     * A test to check whether deposit in vault1 is working well
     */
    function test_vault1Deposit() public {
        //--------(1st Depositor)----------//
        vm.startPrank(msg.sender);
        token.mint(10e6);

        // approving vault
        token.approve(7e6, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);
        // *** Depositing***
        vault1.Deposit(6e6);

        assertEq(token.balanceOf(msg.sender), 4e6);
        assertEq(vault1.getBalanceOf(msg.sender), 6e6);

        console2.log("token balance:", token.balanceOf(msg.sender));
        console2.log("vault balance", vault1.balanceOf(msg.sender));
        console2.log("total shares", vault1.getTotalSupply());

        vm.stopPrank();

        //---------(2nd Depositor)--------//
        vm.startPrank(firstUser);
        // minting some tokens to user so he can perform deposit
        token.mint(20e6);

        // approving vault
        token.approve(17e6, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);
        // *** Depositing ***
        vault1.Deposit(17e6);

        assertEq(token.balanceOf(firstUser), 3e6);
        assertEq(vault1.getBalanceOf(firstUser), 17e6);

        console2.log("token balance:", token.balanceOf(firstUser));
        console2.log("vault balance:", vault1.balanceOf(firstUser));
        console2.log("total shares:", vault1.getTotalSupply());

        vm.stopPrank();

        //------------(3rd depositor)-------------//
        vm.startPrank(secondUser);
        // minting some tokens to user so he can perform deposit
        token.mint(111e6);

        // approving vault
        token.approve(100e6, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);
        // *** Depositing ***
        vault1.Deposit(100e6);

        assertEq(token.balanceOf(secondUser), 11e6);
        assertEq(vault1.getBalanceOf(secondUser), 100e6);

        console2.log("token balance: ", token.balanceOf(secondUser));
        console2.log("vault balance: ", vault1.balanceOf(secondUser));
        console2.log("total shares: ", vault1.getTotalSupply());

        vm.stopPrank();
    }

    /**
     * Function to test the withdrawal of deposited assets
     */
    function test_withdrawVault1() public {
        test_vault1Deposit();
        console2.log(
            vault1.balanceOf(0x2e234DAe75C793f67A35089C9d99245E1C58470b)
        );
        console2.log(vault1.getBalanceOf(address(vault1)));

        // 1st withdrawal
        vm.startPrank(msg.sender);

        vault1.Withdraw(5e6);

        assertEq(token.balanceOf(msg.sender), 9e6);
        assertEq(vault1.balanceOf(msg.sender), 1e6);

        console2.log(
            "Total supply after first withdrawal",
            vault1.getTotalSupply()
        );

        vm.stopPrank();

        // 2nd withdrawal

        vm.startPrank(firstUser);

        vault1.Withdraw(16e6);

        assertEq(token.balanceOf(firstUser), 19e6);
        assertEq(vault1.balanceOf(firstUser), 1e6);

        vm.stopPrank();
    }
}
