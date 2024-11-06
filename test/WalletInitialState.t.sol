// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {WalletBaseTest} from "./WalletBase.t.sol";

contract WalletInitialStateTest is WalletBaseTest {
    function test_InitialState() public view {
        assertEq(wallet.owner(), owner);
        assertEq(address(wallet.charity()), address(charity));
        assertEq(wallet.charityPercentage(), charityPercentage);
    }
}
