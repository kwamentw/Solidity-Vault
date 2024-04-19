// SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

// import statements
import {Test, console2} from "forge-std/Test.sol";
import {Vault2} from "../src/Vault.sol";
import {FourbToken} from "../src/ERC20.sol";

/**
 * @title Vaut2 Test
 * @author Kwame4b
 * @notice not advised to deploy this
 */
contract VaultTest is Test {
    // vault
    Vault2 public vault;
    // underlying token of vault
    FourbToken token;

    // depositors address
    address userOne = makeAddr("firstuser");
    address userTwo = makeAddr("secondUSER");

    function setUp() public {
        // custom token declaration
        token = new FourbToken("BBBBTOKEN", "4BTKN", 8, 120);
        // deployed with custom token
        vault = new Vault2(address(token), 1e8);
        // this contract is supposed to be deployed with stake holders deposit to moderate the vault
        vm.prank(address(vault));
        token.mint(1e8);
    }

    /**
     * A test to check whether deposit is working properly
     */
    function test_vaultDeposit() public {
        //---------1st Depositor(Foundry default sender)--------//
        vm.startPrank(msg.sender);

        token.mint(10e8);
        // approving vault to spend tokens
        token.approve(7e8, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);

        // checking vault balance before deposit
        console2.log(
            "Allowance: ",
            token.Allowance(
                msg.sender,
                0x2e234DAe75C793f67A35089C9d99245E1C58470b
            )
        );
        // ***depositing***
        vault.deposit(5e8);

        // checking vault balance after deposit
        console2.log(
            "Allowance after deposit: ",
            token.Allowance(
                msg.sender,
                0x2e234DAe75C793f67A35089C9d99245E1C58470b
            )
        );

        // printing user balance & vault balance to see if deposit was effective.
        console2.log("msg.sender balance", token.balanceOf(msg.sender));
        console2.log("vault balance of user is ", vault.balanceOf(msg.sender));

        // was just trying to know what these addresses are for curiousity and an error probe
        // console2.log("userOne balance is ", token.balanceOf(userOne));
        // console2.log(address(msg.sender));
        // console2.log(address(userOne));
        // console2.log(address(this));
        // console2.log(address(vault));
        // console2.log(address(token));

        // Checking to see whether deposit affected respective accounts
        assertEq(token.balanceOf(msg.sender), 5e8);
        assertGt(vault.balanceOf(msg.sender), 0);

        vm.stopPrank();

        //***********2nd Depositor(userOne)*********** */
        vm.startPrank(userOne);

        token.mint(20e8);
        // approving vault to spend tokens
        token.approve(15e8, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);

        //  allowance before deposit
        console2.log(
            "2nd Allowance  is: ",
            token.Allowance(userOne, 0x2e234DAe75C793f67A35089C9d99245E1C58470b)
        );
        //*****depositing*****//
        vault.deposit(13e8);

        //  allowance after deposit
        console2.log(
            "2nd Allowance after deposit is: ",
            token.Allowance(userOne, 0x2e234DAe75C793f67A35089C9d99245E1C58470b)
        );

        // checking to see if respective balances effected deposit
        assertEq(token.balanceOf(userOne), 7e8);
        assertEq(vault.balanceOf(userOne), 13e8);

        vm.stopPrank();

        ///////////////// 3rd Depostor(userTwo) //////////////////
        vm.startPrank(userTwo);
        token.mint(100e8);
        // approving vault
        token.approve(80e8, 0x2e234DAe75C793f67A35089C9d99245E1C58470b);
        // allowance before deposit
        console2.log(
            "3rd allowance is ",
            token.Allowance(userTwo, 0x2e234DAe75C793f67A35089C9d99245E1C58470b)
        );
        vault.deposit(75e8);
        // allowance after deposit
        console2.log(
            "3rd allowance after deposit is ",
            token.Allowance(userTwo, 0x2e234DAe75C793f67A35089C9d99245E1C58470b)
        );

        // checking whether respective balances have effected deposit
        assertEq(token.balanceOf(userTwo), 25e8);
        assertEq(vault.balanceOf(userTwo), 75e8);

        vm.stopPrank();

        // checking balances of token and vault after all deposits
        console2.log("Total supply is :", token.totalSupply());
        console2.log("Total vault tokens is: ", vault.totalSupply());
    }

    /**
     * A test to check whether withdrawal is working
     */
    function test_vaultWithdraw() public {
        // Users depositing funds
        test_vaultDeposit();

        //-------1st withdrawal(foundry default sender)-------//
        vm.startPrank(msg.sender);

        // ...withdrawing
        vault.withdraw(5e8);

        // balance after withdrawal
        console2.log("your balance is ", token.balanceOf(msg.sender));
        console2.log("Your vault bal is ", vault.balanceOf(msg.sender));

        // checking to see whether withdrawal affected respective balances
        assertEq(token.balanceOf(msg.sender), 10e8);
        assertEq(vault.balanceOf(msg.sender), 0);

        vm.stopPrank();

        // total supply of tokens & vault total after first withdrawal
        console2.log("Total token supply is: ", token.totalSupply());
        console2.log("Total shares in vault is: ", vault.totalSupply());

        //------------2nd Withdrawal(userTwo)------------//
        vm.startPrank(userTwo);

        // ...withdrawing
        vault.withdraw(50e8);

        // respective balances after withdrawal
        console2.log("your balance is: ", token.balanceOf(userTwo));
        console2.log("your vault balance is: ", vault.balanceOf(userTwo));

        // Checking whether 2nd withdrawal effected
        assertEq(token.balanceOf(userTwo), 75e8);
        assertEq(vault.balanceOf(userTwo), 25e8);

        vm.stopPrank();

        // Total tokens supply & vault balance after the second withdrawal
        console2.log("Total token supply is: ", token.totalSupply());
        console2.log(" vault balance is: ", vault.totalSupply());
    }
}
