# LCKY v2 - Architecture Documentation

## Overview

LCKY v2 is a cross-chain token platform that operates on both Ethereum (EVM) and Internet Computer Protocol (ICP). This document provides a comprehensive overview of the system architecture.

## System Components

### 1. Ethereum Implementation

#### Smart Contracts

##### LCKYToken.sol
Main ERC20 token contract with advanced features:

**Key Features:**
- ERC20 compliant
- Mining with halving mechanism (every 4 years)
- Donation with burn and message storage
- ETH donation mechanism
- Emergency SOS function
- Pausable and Ownable for security

**Constants:**
```solidity
MAX_SUPPLY = 108,000,000,000 LCKY (108 billion)
INITIAL_REWARD = 50 LCKY per block
HALVING_INTERVAL = 2,102,400 blocks (~4 years)
MIN_DONATION_ETH = 0.001 ETH
MIN_CLAIM_INTERVAL = 6400 blocks (~1 day)
```

**State Variables:**
- `totalMined`: Total tokens minted through mining
- `totalDonated`: Total tokens burned through donations
- `totalETHDonated`: Total ETH received
- `balances`: User token balances
- `lastClaimBlock`: Last claim block per user
- `donationMessages`: Array of donation messages

**Key Functions:**

1. **Mining/Claiming:**
   - `claim()`: Claim daily reward based on halving schedule
   - `claimInitial()`: One-time claim of 1000 LCKY for new users
   - `getCurrentBlockReward()`: Calculate current block reward

2. **Donations:**
   - `donateWithMessage(amount, message)`: Burn tokens with message
   - `donateETH()`: Send ETH to get LCKY
   - `getDonationMessages(offset, limit)`: Get donation history

3. **Emergency:**
   - `emergencySOS()`: Burn LCKY to get proportional ETH

4. **View Functions:**
   - `getStats()`: Get global statistics
   - `getUserInfo(address)`: Get user-specific information

##### LCKYMultiCurrency.sol
Factory contract for managing multiple currency versions:

- Creates LCKY tokens tied to different fiat currencies
- Supports: USD, RUB, CNY, INR, THB, UAH
- Each token maintains 1:1 peg to its fiat currency (via oracles)

#### Contract Security

1. **OpenZeppelin Libraries:**
   - ERC20: Standard token implementation
   - Ownable: Access control
   - ReentrancyGuard: Prevents reentrancy attacks
   - Pausable: Emergency stop mechanism

2. **Safety Mechanisms:**
   - Rate limiting on claims
   - Balance checks before transfers
   - Integer overflow protection (Solidity 0.8+)
   - Supply cap enforcement

### 2. Internet Computer Implementation

#### Motoko Canisters

##### lcky_backend (main.mo)
Core LCKY token canister implementing ICRC-1 like functionality:

**Key Features:**
- Token management (mint, transfer, burn)
- Mining with halving (time-based instead of block-based)
- Donation with messages
- ICP donation mechanism
- Emergency SOS

**Constants:**
```motoko
MAX_SUPPLY = 108_000_000_000 * 10^18
INITIAL_REWARD = 50 * 10^18
HALVING_INTERVAL = ~4 years in nanoseconds
MIN_DONATION_ICP = 0.1 ICP
MIN_CLAIM_INTERVAL = 1 day in nanoseconds
```

**Key Functions:**

1. **Token Standard:**
   - `name()`, `symbol()`, `decimals()`: Token metadata
   - `totalSupply()`, `balanceOf()`: Token info
   - `transfer()`: Token transfers

2. **Mining:**
   - `claim()`: Daily reward claim
   - `claimInitial()`: One-time initial claim
   - `getCurrentBlockReward()`: Get current reward

3. **Donations:**
   - `donateWithMessage()`: Burn with message
   - `donateICP()`: Send ICP to get LCKY
   - `getDonationMessages()`: Get donation history

4. **Queries:**
   - `getStats()`: Global statistics
   - `getUserInfo()`: User information

##### payment_backend (main.mo)
Payment processing canister:

**Responsibilities:**
- Process ICP payments
- Coordinate with ICRC-1 ledger
- Track payment history
- Calculate exchange rates

**Key Functions:**
- `processPayment()`: Process ICP payment
- `transferICP()`: Transfer ICP via ICRC-1
- `donateICPForLCKY()`: Donate and receive LCKY
- `getPaymentHistory()`: Get user payment history

#### Canister Dependencies

```
internet_identity (remote)
    ↓
icrc1_ledger_canister
    ↓
lcky_backend ←→ payment_backend
    ↓
lcky_frontend
```

### 3. Frontend

#### Technology Stack
- Pure HTML/CSS/JavaScript (no framework for simplicity)
- Web3.js for Ethereum integration
- @dfinity/agent for ICP integration

#### Key Features

1. **Network Switching:**
   - Toggle between Ethereum and ICP
   - Dynamic UI updates based on network

2. **Wallet Integration:**
   - MetaMask for Ethereum
   - Internet Identity for ICP

3. **User Actions:**
   - View statistics
   - Claim tokens
   - Donate with messages
   - Donate crypto for LCKY
   - Emergency SOS
   - View donation messages

4. **Real-time Updates:**
   - Balance updates
   - Transaction status
   - Error handling

## Data Flow

### Ethereum Flow

```
User → MetaMask → LCKYToken Contract → Blockchain
                     ↓
                  Event Logs
                     ↓
                  Frontend Update
```

### ICP Flow

```
User → Internet Identity → payment_backend
                              ↓
                          lcky_backend
                              ↓
                    icrc1_ledger_canister
                              ↓
                          Blockchain
```

## Token Economics

### Emission Schedule

| Period | Years | Reward per Block/Day | Total Minted (approx) |
|--------|-------|---------------------|----------------------|
| 1      | 0-4   | 50 LCKY             | ~52.5 billion        |
| 2      | 4-8   | 25 LCKY             | ~26.25 billion       |
| 3      | 8-12  | 12.5 LCKY           | ~13.125 billion      |
| 4      | 12-16 | 6.25 LCKY           | ~6.5625 billion      |
| ...    | ...   | ...                 | ...                  |

**Total Supply:** Approaches 108 billion but never reaches it (geometric series)

### Distribution

- **70%** - Mining/Claiming (over time)
- **15%** - Team & Development (vested)
- **10%** - Community & Marketing
- **5%** - Initial liquidity & reserves

### Exchange Rates

**Ethereum:**
- 1 ETH = 10,000 LCKY

**ICP:**
- 1 ICP = 100 LCKY

**Fiat (via stablecoins):**
- Dynamic based on market conditions

## Security Considerations

### Smart Contract Security

1. **Access Control:**
   - Owner-only functions for critical operations
   - Multi-sig recommended for production

2. **Economic Security:**
   - Rate limiting prevents spam
   - Supply cap prevents inflation
   - Burning mechanism reduces supply

3. **Emergency Procedures:**
   - Pause mechanism for emergencies
   - Emergency withdraw for owner
   - SOS function for users

### ICP Security

1. **Canister Security:**
   - Stable storage for persistence
   - Upgrade mechanisms
   - Access control on critical functions

2. **Cycles Management:**
   - Monitor cycle balance
   - Auto-refill mechanisms
   - Blackhole canister for final deployment

## Deployment Guide

### Ethereum Deployment

```bash
cd ethereum
npm install
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.ts --network <network>
```

### ICP Deployment

```bash
cd icp
dfx start --background
dfx deploy
```

See `deploy.sh` scripts for detailed deployment procedures.

## Testing Strategy

### Unit Tests
- Test each function in isolation
- Edge cases and error conditions
- Gas optimization

### Integration Tests
- Multi-contract interactions
- Cross-canister calls
- Frontend integration

### Security Audits
- Static analysis (Slither, MythX)
- Manual code review
- External audit (recommended for mainnet)

## Monitoring & Maintenance

### Key Metrics to Monitor

1. **Token Metrics:**
   - Total supply
   - Circulating supply
   - Burn rate
   - Mining rate

2. **User Metrics:**
   - Active users
   - Transaction volume
   - Claim frequency

3. **Economic Metrics:**
   - ETH/ICP balance
   - Exchange rate stability
   - Donation volume

### Maintenance Tasks

1. **Regular:**
   - Monitor contract balance
   - Check for stuck transactions
   - Update frontend

2. **Periodic:**
   - Security audits
   - Performance optimization
   - Feature updates

## Future Enhancements

1. **Cross-chain Bridge:**
   - Direct bridge between Ethereum and ICP
   - Wrapped tokens on other chains

2. **DeFi Integration:**
   - DEX liquidity pools
   - Yield farming
   - Staking mechanisms

3. **Governance:**
   - DAO implementation
   - Community voting
   - Proposal system

4. **Mobile App:**
   - Native iOS/Android apps
   - Push notifications
   - QR code payments

5. **Oracle Integration:**
   - Chainlink for Ethereum
   - ICP oracles for price feeds
   - Real-time fiat pegs

## Contact & Support

- **GitHub:** [Repository URL]
- **Discord:** [Discord invite]
- **Email:** info@lckycoin.com
- **Twitter:** @lckycoin

## License

MIT License - See LICENSE file for details

---

*Last Updated: 2025-01-16*
*Version: 2.0.0*

