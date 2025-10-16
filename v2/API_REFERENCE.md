# LCKY v2 - API Reference

## Ethereum Smart Contract API

### LCKYToken Contract

#### Read Functions (View/Pure)

##### `name() → string`
Returns the token name.
```solidity
function name() public view returns (string memory)
```
**Returns:** `"Lucky Coin"`

##### `symbol() → string`
Returns the token symbol.
```solidity
function symbol() public view returns (string memory)
```
**Returns:** `"LCKY"`

##### `decimals() → uint8`
Returns the number of decimals.
```solidity
function decimals() public view returns (uint8)
```
**Returns:** `18`

##### `totalSupply() → uint256`
Returns the total token supply.
```solidity
function totalSupply() public view returns (uint256)
```

##### `balanceOf(address account) → uint256`
Returns the balance of an account.
```solidity
function balanceOf(address account) public view returns (uint256)
```

##### `getCurrentBlockReward() → uint256`
Returns the current mining reward per block.
```solidity
function getCurrentBlockReward() public view returns (uint256)
```

##### `getStats() → Stats`
Returns global statistics.
```solidity
function getStats() public view returns (
    uint256 _totalSupply,
    uint256 _totalMined,
    uint256 _totalDonated,
    uint256 _totalETHDonated,
    uint256 _currentBlockReward,
    uint256 _contractETHBalance,
    uint256 _donationCount
)
```

##### `getUserInfo(address user) → UserInfo`
Returns user-specific information.
```solidity
function getUserInfo(address user) public view returns (
    uint256 balance,
    uint256 mined,
    uint256 lastClaim,
    bool claimedInitial,
    bool canClaim
)
```

##### `getDonationMessagesCount() → uint256`
Returns the total number of donation messages.
```solidity
function getDonationMessagesCount() external view returns (uint256)
```

##### `getDonationMessages(uint256 offset, uint256 limit) → DonationMessage[]`
Returns donation messages with pagination.
```solidity
function getDonationMessages(uint256 offset, uint256 limit) 
    external view returns (DonationMessage[] memory)
```

#### Write Functions

##### `claimInitial() → uint256`
Claims the initial 1000 LCKY (one-time only).
```solidity
function claimInitial() external nonReentrant whenNotPaused returns (uint256)
```
**Requirements:**
- Must not have claimed before
- Total mined must not exceed max supply

**Returns:** Amount of LCKY claimed

**Events:** `Claimed(address indexed user, uint256 amount, uint256 blockNumber)`

##### `claim() → uint256`
Claims the daily mining reward.
```solidity
function claim() external nonReentrant whenNotPaused returns (uint256)
```
**Requirements:**
- Must wait 6400 blocks (~1 day) since last claim
- Rewards must be available
- Total mined must not exceed max supply

**Returns:** Amount of LCKY claimed

##### `transfer(address to, uint256 amount) → bool`
Transfers tokens to another address.
```solidity
function transfer(address to, uint256 amount) public returns (bool)
```

##### `donateWithMessage(uint256 amount, string memory message)`
Burns tokens with a message.
```solidity
function donateWithMessage(uint256 amount, string memory message) 
    external nonReentrant whenNotPaused
```
**Requirements:**
- Amount must be > 0
- Message length ≤ 280 characters
- Sufficient balance

**Events:** `DonationWithMessage(address indexed donor, uint256 amount, string message)`

##### `donateETH() → uint256` (payable)
Donates ETH to receive LCKY.
```solidity
function donateETH() external payable nonReentrant whenNotPaused returns (uint256)
```
**Requirements:**
- msg.value ≥ MIN_DONATION_ETH (0.001 ETH)
- Would not exceed max supply

**Returns:** Amount of LCKY received

**Exchange Rate:** 1 ETH = 10,000 LCKY

**Events:** `ETHDonated(address indexed donor, uint256 ethAmount, uint256 lckyReceived)`

##### `emergencySOS() → uint256`
Burns all LCKY to receive proportional ETH.
```solidity
function emergencySOS() external nonReentrant whenNotPaused returns (uint256)
```
**Requirements:**
- Must have LCKY balance
- Contract must have ETH balance

**Returns:** Amount of ETH received

**Formula:** `ethAmount = (userBalance * contractETHBalance) / totalSupply`

**Events:** `EmergencySOS(address indexed user, uint256 lckyBurned, uint256 ethReceived)`

#### Admin Functions (Owner Only)

##### `pause()`
Pauses all token operations.
```solidity
function pause() external onlyOwner
```

##### `unpause()`
Unpauses token operations.
```solidity
function unpause() external onlyOwner
```

##### `setTokenURI(string memory newURI)`
Updates the token metadata URI.
```solidity
function setTokenURI(string memory newURI) external onlyOwner
```

##### `emergencyWithdraw(uint256 amount)`
Emergency withdrawal of ETH (owner only).
```solidity
function emergencyWithdraw(uint256 amount) external onlyOwner
```

---

## ICP Canister API

### lcky_backend Canister

#### Query Functions

##### `name() → Text`
Returns the token name.
```motoko
public query func name() : async Text
```
**Returns:** `"Lucky Coin"`

##### `symbol() → Text`
Returns the token symbol.
```motoko
public query func symbol() : async Text
```
**Returns:** `"LCKY"`

##### `decimals() → Nat8`
Returns the number of decimals.
```motoko
public query func decimals() : async Nat8
```
**Returns:** `18`

##### `totalSupply() → Nat`
Returns the total token supply.
```motoko
public query func totalSupply() : async Nat
```

##### `balanceOf(Principal) → Nat`
Returns the balance of an account.
```motoko
public query func balanceOf(account: Principal) : async Nat
```

##### `getCurrentBlockReward() → Nat`
Returns the current reward.
```motoko
public query func getCurrentBlockReward() : async Nat
```

##### `getStats() → Stats`
Returns global statistics.
```motoko
public query func getStats() : async Stats

type Stats = {
    totalSupply : Nat;
    totalMined : Nat;
    totalDonated : Nat;
    totalICPDonated : Nat;
    currentBlockReward : Nat;
    contractICPBalance : Nat;
    donationCount : Nat;
}
```

##### `getUserInfo(Principal) → UserInfo`
Returns user information.
```motoko
public query func getUserInfo(user: Principal) : async UserInfo

type UserInfo = {
    balance : Nat;
    mined : Nat;
    lastClaimTime : Int;
    claimedInitial : Bool;
    canClaim : Bool;
}
```

##### `getDonationMessages(Nat, Nat) → [DonationMessage]`
Returns donation messages with pagination.
```motoko
public query func getDonationMessages(offset: Nat, limit: Nat) : async [DonationMessage]

type DonationMessage = {
    donor : Principal;
    amount : Nat;
    message : Text;
    timestamp : Int;
}
```

#### Update Functions

##### `claimInitial() → Result<Nat, Text>`
Claims initial 1000 LCKY (one-time).
```motoko
public shared(msg) func claimInitial() : async Result.Result<Nat, Text>
```
**Returns:** `#ok(amount)` or `#err(message)`

##### `claim() → Result<Nat, Text>`
Claims daily reward.
```motoko
public shared(msg) func claim() : async Result.Result<Nat, Text>
```
**Requirements:**
- Must wait 1 day since last claim
- Rewards must be available

##### `transfer(Principal, Nat) → Result<(), Text>`
Transfers tokens.
```motoko
public shared(msg) func transfer(to: Principal, amount: Nat) : async Result.Result<(), Text>
```

##### `donateWithMessage(Nat, Text) → Result<(), Text>`
Burns tokens with message.
```motoko
public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result.Result<(), Text>
```
**Requirements:**
- Amount > 0
- Message length ≤ 280
- Sufficient balance

##### `donateICP() → Result<Nat, Text>`
Donates ICP to receive LCKY.
```motoko
public shared(msg) func donateICP() : async Result.Result<Nat, Text>
```
**Requirements:**
- Attached cycles ≥ 0.1 ICP
- Would not exceed max supply

**Exchange Rate:** 1 ICP = 100 LCKY

##### `emergencySOS() → Result<Nat, Text>`
Burns LCKY for proportional ICP.
```motoko
public shared(msg) func emergencySOS() : async Result.Result<Nat, Text>
```

### payment_backend Canister

#### Query Functions

##### `getStats() → PaymentStats`
Returns payment statistics.
```motoko
public query func getStats() : async {
    totalPayments : Nat;
    totalProcessed : Nat;
    totalLCKYDistributed : Nat;
}
```

##### `getExchangeRate() → Nat`
Returns the ICP to LCKY exchange rate.
```motoko
public query func getExchangeRate() : async Nat
```

##### `getMinimumPayment() → Nat`
Returns minimum payment amount.
```motoko
public query func getMinimumPayment() : async Nat
```

##### `calculateLCKYAmount(Nat) → Nat`
Calculates LCKY for given ICP amount.
```motoko
public query func calculateLCKYAmount(icpAmount: Nat) : async Nat
```

##### `getPaymentHistory(Principal, Nat) → [PaymentRecord]`
Returns payment history for a user.
```motoko
public query func getPaymentHistory(user: Principal, limit: Nat) : async [PaymentRecord]
```

#### Update Functions

##### `processPayment(Nat) → Result<Nat, Text>`
Processes an ICP payment.
```motoko
public shared({ caller }) func processPayment(icpAmount: Nat) : async Result.Result<Nat, Text>
```

##### `donateICPForLCKY(Nat) → Result<Nat, Text>`
Donates ICP and receives LCKY.
```motoko
public shared({ caller }) func donateICPForLCKY(icpAmount: Nat) : async Result.Result<Nat, Text>
```

---

## Web3.js Integration (JavaScript)

### Setup

```javascript
const Web3 = require('web3');
const web3 = new Web3('https://mainnet.infura.io/v3/YOUR_KEY');

const contractAddress = '0x...';
const abi = [...]; // Contract ABI

const contract = new web3.eth.Contract(abi, contractAddress);
```

### Examples

#### Get Balance
```javascript
const balance = await contract.methods.balanceOf(address).call();
console.log('Balance:', web3.utils.fromWei(balance, 'ether'), 'LCKY');
```

#### Claim Tokens
```javascript
const account = web3.eth.accounts[0];
const tx = await contract.methods.claim().send({ from: account });
console.log('Claimed! TX:', tx.transactionHash);
```

#### Donate with Message
```javascript
const amount = web3.utils.toWei('100', 'ether');
const message = 'For the temple!';

const tx = await contract.methods.donateWithMessage(amount, message).send({
    from: account
});
```

#### Donate ETH
```javascript
const ethAmount = web3.utils.toWei('1', 'ether');

const tx = await contract.methods.donateETH().send({
    from: account,
    value: ethAmount
});
```

---

## ICP Agent Integration (JavaScript)

### Setup

```javascript
import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory } from './lcky_backend.did.js';

const canisterId = 'xxxxx-xxxxx-xxxxx-xxxxx-cai';

const agent = new HttpAgent({ host: 'https://ic0.app' });
const actor = Actor.createActor(idlFactory, {
    agent,
    canisterId,
});
```

### Examples

#### Get Balance
```javascript
const principal = Principal.fromText('...');
const balance = await actor.balanceOf(principal);
console.log('Balance:', balance);
```

#### Claim Tokens
```javascript
const result = await actor.claim();
if ('ok' in result) {
    console.log('Claimed:', result.ok);
} else {
    console.error('Error:', result.err);
}
```

#### Donate with Message
```javascript
const amount = 100_000_000_000_000_000_000n; // 100 LCKY
const message = 'For the temple!';

const result = await actor.donateWithMessage(amount, message);
```

---

## Error Codes

### Ethereum

| Error | Description | Solution |
|-------|-------------|----------|
| `Claim too soon` | Less than 1 day since last claim | Wait for cooldown period |
| `Already claimed initial amount` | Initial claim already done | Use regular claim() |
| `Max supply reached` | No more tokens to mint | - |
| `Insufficient balance` | Not enough LCKY | Get more tokens |
| `Message too long` | Message > 280 chars | Shorten message |
| `Donation too small` | ETH amount < minimum | Increase donation |

### ICP

Similar error messages returned as `#err(Text)` in Result types.

---

## Rate Limits

### Ethereum
- Claim: Once per ~6400 blocks (~1 day)
- No limits on: transfers, donations, SOS

### ICP
- Claim: Once per 86400 seconds (1 day)
- Query calls: No limits
- Update calls: Limited by cycles

---

For more information, see the [Architecture Documentation](ARCHITECTURE.md).

