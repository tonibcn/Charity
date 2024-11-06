// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Charity} from "../src/Charity.sol";

abstract contract CharityBaseTest is Test {
    Charity charity;

    uint256 public moneyCollectingDeadline = 10 days;
    address owner = address(1);
    address donator = address(2);
    uint256 donationAmount = 1 ether;

    function setUp() public virtual {
        charity = new Charity(owner, moneyCollectingDeadline);
    }

    function _donate(address from, uint256 amount) internal {
        vm.prank(from);
        charity.donate{value: amount}();
    }

    function _withdraw(address to, uint256 amount) internal {
        vm.prank(to);
        charity.withdraw(amount);
    }
}
