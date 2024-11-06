// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {WalletBaseTest} from "./WalletBase.t.sol";
import {Wallet} from "../../../src/homework/02/Wallet.sol";
import {FakeOwner} from "./FakeOwner.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WalletWithdrawTest is WalletBaseTest {
    /*
        Withdraw:
        Test withdraw - happy path
        Test when not owner - unhappy path
        Test when not enough money - unhappy path
        Test when transfer failed - unhappy path
    */

    function setUp() public override {
        super.setUp();
        deal(address(wallet), depositAmount);
    }

    function test_Withdraw() public {
        uint256 expectedWithdrawAmount = address(wallet).balance;

        _withdraw(owner, expectedWithdrawAmount);

        assertEq(address(wallet).balance, 0);
        assertEq(owner.balance, expectedWithdrawAmount);
    }

    function test_RevertWhen_NotOwner() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                address(this)
            )
        );
        _withdraw(address(this), 0);
    }

    function test_RevertWhen_NotEnoughMoney() public {
        vm.expectRevert(Wallet.NotEnoughMoney.selector);
        _withdraw(owner, depositAmount + 1);
    }

    function test_RevertWhen_TransferFailed() public {
        FakeOwner fakeOwner = new FakeOwner();
        wallet = new Wallet(
            address(fakeOwner),
            address(charity),
            charityPercentage
        );

        deal(address(wallet), depositAmount);

        vm.expectRevert(Wallet.TransferFailed.selector);
        _withdraw(address(fakeOwner), address(wallet).balance);
    }
}
