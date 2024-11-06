// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {CharityBaseTest} from "./CharityBase.t.sol";

contract CharityInitialStateTest is CharityBaseTest {
    function test_InitialState() public view {
        uint256 expectedDeadline = block.timestamp + moneyCollectingDeadline;
        assertEq(charity.owner(), owner);
        assertEq(charity.moneyCollectingDeadline(), expectedDeadline);
    }
}
