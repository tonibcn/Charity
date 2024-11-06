// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {ICharity} from "./ICharity.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Wallet is Ownable {
    ICharity public charity;

    uint256 public immutable charityPercentage;

    error NotEnoughDeposit();
    error NotEnoughMoney();
    error TransferFailed();

    constructor(
        address _owner,
        address _charityAddress,
        uint256 _charityPercentage
    ) Ownable(_owner) {
        charity = ICharity(_charityAddress);
        charityPercentage = _charityPercentage;
    }

    function deposit() external payable {
        if (msg.value == 0) {
            revert NotEnoughDeposit();
        }

        if (charity.canDonate()) {
            uint256 charityAmount = (msg.value * charityPercentage) / 1000;
            charity.donate{value: charityAmount}();
        }
    }

    function withdraw(uint256 amount) external onlyOwner {
        uint256 currentBalance = address(this).balance;
        if (amount > currentBalance) {
            revert NotEnoughMoney();
        }

        (bool success, ) = payable(msg.sender).call{value: amount}("");

        if (!success) {
            revert TransferFailed();
        }
    }
}