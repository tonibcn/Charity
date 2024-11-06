// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Charity} from "../../../src/homework/02/Charity.sol";
import {CharityBaseTest} from "./CharityBase.t.sol";
import {FakeOwner} from "./FakeOwner.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract CharityWithdrawTest is CharityBaseTest {
    /*
        Withdraw:
        Test withdraw - happy path
        Test when not owner - unhappy path
        Test when not enough money - unhappy path
        Test when transfer failed - unhappy path
    */

    function setUp() public override {
        super.setUp();
        //We add some additional configurations
        deal(address(charity), donationAmount);
    }

    function test_Withdraw() public {
        uint256 expectedDonatedAmount = donationAmount;
        vm.expectEmit(true, true, true, true);
        emit Charity.Withdrawn(expectedDonatedAmount);

        _withdraw(owner, expectedDonatedAmount);

        assertEq(address(charity).balance, 0);
        assertEq(owner.balance, expectedDonatedAmount);
    }

    function test_RevertWhen_NotOwner() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                address(this)
            )
        );
        _withdraw(address(this), donationAmount);
    }

    function test_RevertWhen_NotEnoughMoney() public {
        vm.expectRevert(Charity.NotEnoughMoney.selector);
        _withdraw(owner, donationAmount + 1);
    }

    function test_RevertWhen_TransferFailed() public {
        //We use a fake contract to force the failure
        FakeOwner fakeOwner = new FakeOwner();
        charity = new Charity(address(fakeOwner), moneyCollectingDeadline);

        deal(address(charity), donationAmount);

        vm.expectRevert(Charity.TransferFailed.selector);
        _withdraw(address(fakeOwner), donationAmount);
    }
}
