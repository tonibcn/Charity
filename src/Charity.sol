// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Charity is Ownable {
    event Donated(address indexed donator, uint256 amount);
    event Withdrawn(uint256 amount);

    error CanNotDonateAnymore();
    error NotEnoughDonationAmount();
    error NotEnoughMoney();
    error TransferFailed();

    mapping(address => uint256) public userDonations;

    uint256 public moneyCollectingDeadline;

    constructor(address _owner, uint256 _moneyCollectingDeadline) Ownable(_owner) {
        moneyCollectingDeadline = block.timestamp + _moneyCollectingDeadline;
    }

    function donate() external payable {
        if (!canDonate()) {
            revert CanNotDonateAnymore();
        }
        if(msg.value == 0) {
            revert NotEnoughDonationAmount();
        }

        userDonations[msg.sender] += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    function canDonate() public view returns(bool) {
        return moneyCollectingDeadline > block.timestamp;
    }

    function withdraw(uint256 amount) external onlyOwner {
        uint256 currentBalance = address(this).balance;
        if(amount > currentBalance) {
            revert NotEnoughMoney();
        }

        (bool success, ) = payable(msg.sender).call{value: amount}("");

        if(!success) {
            revert TransferFailed();
        }

        emit Withdrawn(currentBalance);
    }
}
