## Develop two Solidity smart contracts: `Charity` and `Wallet`.

- **Charity Contract**: A simple donation contract where users can donate Ether. It logs donations and maintains a mapping of user donations.
- **Wallet Contract**: A contract that can deposit Ether and donate a portion to a charity. It also allows the owner to withdraw funds. It calculates the donation amount based on a percentage and interacts with the `Charity` contract.

## Objective

- The `Charity` contract handles donations and records the amount donated by each user.
- The `Wallet` contract manages deposits, sends a percentage of the deposit to the `Charity` contract, and allows the owner to withdraw funds.
- Ensure error handling and proper event logging in both contracts.

## Additional Information

### Charity Contract

- **State Variables**:

  - `userDonations`: A mapping from user addresses to the total amount they have donated.

- **Custom Errors**:

  - `NotEnoughDonation()`: Reverted if the donation amount is zero.

- **Events**:

  - `Donated`: Emitted when a donation is made, logging the donor and the amount donated.

- **Functions**:
  - `donate()`: Allows users to donate Ether. Requires a non-zero donation amount and updates the `userDonations` mapping.

### Wallet Contract

- **State Variables**:

  - `owner`: The address of the contract owner.
  - `charity`: An instance of the `ICharity` interface for interacting with the `Charity` contract.
  - `CHARTY_PERCENTAGE`: A constant representing the percentage of the deposit to donate (50 corresponds to 5.0%).
  - `moneyCollectingDeadline`: A deadline after which is not posible to make a donation

- **Custom Errors**:

  - `NotEnoughDeposit()`: Reverted if the deposit amount is zero.
  - `NotOwner()`: Reverted if a non-owner attempts to withdraw funds.
  - `NotEnoughMoney()`: Reverted if the withdrawal amount exceeds the contract balance.
  - `TransferFailed()`: Reverted if the Ether transfer fails.
  - `CanNotDonateAnymore()`: Reverted if the current blockstamp is greater than the `moneyCollectingDeadline`.

- **Functions**:
  - `deposit()`: Accepts Ether deposits and calculates a donation amount based on `CHARTY_PERCENTAGE`. Donates the calculated amount to the `Charity` contract.
  - `withdraw(uint256 amount)`: Allows the owner to withdraw a specified amount of Ether. Ensures sufficient balance and successful transfer.

### Integration

- The `Wallet` contract interacts with the `Charity` contract via the `ICharity` interface to handle donations. The donation amount is calculated as a percentage of the deposited Ether and sent directly to the `Charity` contract.
