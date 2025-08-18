// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address charlie = makeAddr("charlie");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant INITIAL_SUPPLY = 100 ether;

    // Define ERC20 events for testing
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    // Test 1: Verify Bob's balance after setup
    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    // Test 2: Verify token metadata (name, symbol, decimals)
    function testTokenMetadata() public {
        assertEq(ourToken.name(), "OurToken");
        assertEq(ourToken.symbol(), "OT");
        assertEq(ourToken.decimals(), 18);
    }

    // Test 3: Verify total supply after deployment
    function testTotalSupply() public {
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY);
    }

    // Test 4: Verify initial supply is minted to deployer
    function testInitialSupplyToDeployer() public {
        // Since setUp transfers STARTING_BALANCE to Bob, deployer should have 0
        assertEq(ourToken.balanceOf(msg.sender), 0);
        // Verify total supply is correct
        assertEq(
            ourToken.balanceOf(bob) + ourToken.balanceOf(msg.sender),
            INITIAL_SUPPLY
        );
    }

    // Test 5: Test direct transfer
    function testTransfer() public {
        uint256 transferAmount = 50 ether;
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    // Test 6: Test transfer with insufficient balance
    function testTransferInsufficientBalance() public {
        uint256 transferAmount = STARTING_BALANCE + 1 ether;
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(alice, transferAmount);
    }

    // Test 7: Test allowances and transferFrom
    function testAllowances() public {
        uint256 initialAllowance = 1000;
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(
            ourToken.allowance(bob, alice),
            initialAllowance - transferAmount
        );
    }

    // Test 8: Test transferFrom with insufficient allowance
    function testTransferFromInsufficientAllowance() public {
        uint256 initialAllowance = 100;
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = initialAllowance + 1;
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, transferAmount);
    }

    // Test 9: Test transfer to zero address
    function testTransferToZeroAddress() public {
        uint256 transferAmount = 50 ether;
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(address(0), transferAmount);
    }

    // Test 10: Test transferFrom to zero address
    function testTransferFromToZeroAddress() public {
        uint256 initialAllowance = 1000;
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, address(0), 500);
    }

    // Test 11: Test approval event emission
    function testApprovalEvent() public {
        uint256 approvalAmount = 1000;
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Approval(bob, alice, approvalAmount);
        ourToken.approve(alice, approvalAmount);
    }

    // Test 12: Test transfer event emission
    function testTransferEvent() public {
        uint256 transferAmount = 50 ether;
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Transfer(bob, alice, transferAmount);
        ourToken.transfer(alice, transferAmount);
    }

    // Test 13: Test multiple approvals
    function testMultipleApprovals() public {
        uint256 firstAllowance = 1000;
        uint256 secondAllowance = 500;
        vm.prank(bob);
        ourToken.approve(alice, firstAllowance);
        assertEq(ourToken.allowance(bob, alice), firstAllowance);

        vm.prank(bob);
        ourToken.approve(alice, secondAllowance);
        assertEq(ourToken.allowance(bob, alice), secondAllowance);
    }

    // Test 14: Test deployment script returns correct contract
    function testDeployScript() public {
        DeployOurToken newDeployer = new DeployOurToken();
        OurToken deployedToken = newDeployer.run();
        assertEq(deployedToken.totalSupply(), INITIAL_SUPPLY);
        assertEq(deployedToken.balanceOf(msg.sender), INITIAL_SUPPLY);
    }

    // Test 15: Test zero amount transfer
    function testZeroAmountTransfer() public {
        vm.prank(bob);
        ourToken.transfer(alice, 0);
        assertEq(ourToken.balanceOf(alice), 0);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }
}
