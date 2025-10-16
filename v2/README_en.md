# LCKY v2 - Multi-Chain Lucky Coin Platform 🪄🍯

**Languages:** **English** | [中文](README_cn.md) | [ไทย](README_th.md) | [हिंदी](README_hi.md) | [עברית](README_he.md) | [Русский](README.md)

## About the Project

LCKY v2 is a cross-chain magical coin platform operating on both Ethereum (ERC20) and Internet Computer (ICRC1).

## Project Philosophy

The project is inspired by the movie "Pay It Forward" - about how one person can change the world by doing good to others.

[![Pay It Forward Trailer](https://img.youtube.com/vi/TlZDDACt8Nw/0.jpg)](https://www.youtube.com/watch?v=TlZDDACt8Nw)

🎬 [Watch "Pay It Forward" Trailer](https://www.youtube.com/watch?v=TlZDDACt8Nw)

## Key Features

### LCKY Coin Emission
The magic pot produces the enchanting emission of LCKY Coin 🌟. The cherished number is 108 billion coins, but like true magic, we'll never reach this limit. Every four years, the magic of our pot diminishes, halving the emission rate ⏳.

**Emission Formula:**
- Initial rate: 50 LCKY per block
- Halving: Every 4 years (approximately every 2,102,400 blocks on Ethereum)
- Maximum emission: 108,000,000,000 LCKY (will never be reached)

### Magical Distribution
The chief wizard distributes LCKY Coin through a claiming system, giving coins to people and supporting good causes 🏰🤝.

### Donation Fire (Burning with Message)
LCKY coins can be donated by burning them and leaving an eternal message on the blockchain 💬.

### Donation Ether (Reserve Replenishment)
Send ETH or ICP to the magic pot, and it will generously reward you with LCKY coins 🌈.

**Exchange Rate:** Dynamic, depends on contract reserve

### SOS Function (Emergency Exit)
In case of extreme necessity, you can activate SOS, receiving ETH/ICP proportional to your LCKY balance 🚨.

**Formula:** `your_ETH = (your_LCKY / total_supply) * contract_balance`

## Project Architecture

```
LCKY/v2/
├── ethereum/               # ERC20 implementation
│   ├── contracts/          # Solidity contracts
│   ├── scripts/            # Deploy scripts
│   └── test/               # Tests
│
├── icp/                    # ICP implementation
│   ├── src/
│   │   ├── lcky_backend/   # ICRC1 token
│   │   ├── payment_backend/# Payment backend
│   │   └── lcky_frontend/  # Frontend
│   └── dfx.json
│
├── frontend/               # Common frontend
│   └── src/
│
└── docs/                   # Documentation
```

## Supported Platforms

### Ethereum (EVM Compatible)
- Ethereum Mainnet
- Polygon
- BSC
- Arbitrum
- Optimism

### Internet Computer
- ICP Mainnet
- ICP Local Replica

## Tokenomics

- **Total Supply:** 108,000,000,000 LCKY (theoretical maximum)
- **Initial Emission:** 50 LCKY/block
- **Halving:** Every 4 years
- **Decimals:** 18
- **Distribution:**
  - 70% - Mining/Claiming
  - 15% - Team & Development
  - 10% - Community & Marketing
  - 5% - Reserve

## Quick Start

### Ethereum

```bash
cd ethereum
npm install
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.ts --network localhost
```

### ICP

```bash
cd icp
dfx start --background
dfx deploy
```

## Main Contract Functions

### ERC20 (Ethereum)

```solidity
// Claim coins (emission)
function claim() external returns (uint256)

// Donation with burning
function donateWithMessage(uint256 amount, string memory message) external

// Donate ETH to receive LCKY
function donateETH() external payable returns (uint256)

// SOS - emergency ETH withdrawal
function emergencySOS() external returns (uint256)

// Get current block reward
function getCurrentBlockReward() external view returns (uint256)
```

### ICRC1 (ICP)

```motoko
// Claim coins
public shared(msg) func claim() : async Result<Nat, Text>

// Donation with message
public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result<(), Text>

// Donate ICP
public shared(msg) func donateICP() : async Result<Nat, Text>

// SOS function
public shared(msg) func emergencySOS() : async Result<Nat, Text>
```

## DEX Integration

LCKY tokens can be freely traded on decentralized exchanges:
- **Ethereum:** Uniswap, Sushiswap
- **ICP:** ICPSwap, Sonic

## Security

- ✅ Audited by [TBD]
- ✅ OpenZeppelin libraries
- ✅ Reentrancy protection
- ✅ Rate limiting
- ✅ Emergency pause

## License

MIT License

## Contacts

- Website: https://lckycoin.com
- Twitter: @lckycoin
- Discord: https://discord.gg/lckycoin
- Email: info@lckycoin.com

---

**Important:** These are magic coins, but invest responsibly! 🪄✨

