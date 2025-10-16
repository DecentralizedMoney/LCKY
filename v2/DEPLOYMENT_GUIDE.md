# LCKY v2 - Deployment Guide

## Prerequisites

### For Ethereum Deployment

1. **Node.js & npm**
   ```bash
   node --version  # Should be v16 or higher
   npm --version   # Should be v8 or higher
   ```

2. **Hardhat**
   ```bash
   npm install --global hardhat
   ```

3. **Wallet Setup**
   - Private key with ETH for gas fees
   - For testnets: Get free ETH from faucets

4. **API Keys**
   - Infura/Alchemy for RPC endpoints
   - Etherscan for contract verification

### For ICP Deployment

1. **DFX SDK**
   ```bash
   sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
   dfx --version  # Should be v0.15.0 or higher
   ```

2. **Cycles**
   - For mainnet deployment
   - Get from cycles faucet or exchange

3. **Mops (Motoko Package Manager)**
   ```bash
   npm install -g ic-mops
   ```

## Ethereum Deployment

### Step 1: Setup

```bash
cd LCKY/v2/ethereum
npm install
```

### Step 2: Configure Environment

Create `.env` file:
```env
# RPC URLs
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_KEY
MAINNET_RPC_URL=https://mainnet.infura.io/v3/YOUR_KEY

# Deployer private key (KEEP SECRET!)
PRIVATE_KEY=your_private_key_here

# API Keys for verification
ETHERSCAN_API_KEY=your_etherscan_key
```

⚠️ **NEVER commit .env file to git!**

### Step 3: Compile Contracts

```bash
npx hardhat compile
```

Expected output:
```
Compiled 15 Solidity files successfully
```

### Step 4: Run Tests

```bash
npx hardhat test
```

All tests should pass:
```
  LCKYToken
    ✓ Should deploy correctly
    ✓ Should allow claiming
    ✓ Should process donations
    ...
  
  65 passing (5s)
```

### Step 5: Deploy to Local Network (Testing)

Terminal 1 - Start local node:
```bash
npx hardhat node
```

Terminal 2 - Deploy:
```bash
npx hardhat run scripts/deploy.ts --network localhost
```

### Step 6: Deploy to Testnet (Sepolia)

```bash
npx hardhat run scripts/deploy.ts --network sepolia
```

Save the deployed addresses!

### Step 7: Verify Contracts

```bash
npx hardhat verify --network sepolia <CONTRACT_ADDRESS>
```

### Step 8: Deploy to Mainnet

⚠️ **FINAL CHECKLIST:**
- [ ] All tests passing
- [ ] Security audit completed
- [ ] Contract verified on testnet
- [ ] Frontend tested with testnet
- [ ] Sufficient ETH for deployment
- [ ] Multisig setup for ownership

```bash
npx hardhat run scripts/deploy.ts --network mainnet
```

## ICP Deployment

### Step 1: Setup

```bash
cd LCKY/v2/icp
mops install
```

### Step 2: Start Local Replica (for testing)

```bash
dfx start --background --clean
```

### Step 3: Create Canisters

```bash
dfx canister create --all
```

### Step 4: Build

```bash
dfx build
```

### Step 5: Deploy Locally

```bash
# Deploy ICRC1 Ledger
dfx deploy icrc1_ledger_canister --argument '(record {
  token_name = "Lucky Coin";
  token_symbol = "LCKY";
  minting_account = record { owner = principal "'$(dfx identity get-principal)'"; };
  initial_balances = vec {};
  transfer_fee = 10_000;
  metadata = vec {};
  archive_options = record {
    trigger_threshold = 2000;
    num_blocks_to_archive = 1000;
    controller_id = principal "'$(dfx identity get-principal)'";
  };
})'

# Deploy LCKY Backend
dfx deploy lcky_backend

# Deploy Payment Backend
dfx deploy payment_backend

# Deploy Frontend
dfx deploy lcky_frontend
```

### Step 6: Test Locally

Get canister IDs:
```bash
dfx canister id lcky_backend
dfx canister id payment_backend
dfx canister id lcky_frontend
```

Test functions:
```bash
# Get stats
dfx canister call lcky_backend getStats '()'

# Claim initial tokens
dfx canister call lcky_backend claimInitial '()'

# Check balance
dfx canister call lcky_backend balanceOf "(principal \"$(dfx identity get-principal)\")"
```

Open frontend:
```bash
FRONTEND_ID=$(dfx canister id lcky_frontend)
echo "http://${FRONTEND_ID}.localhost:4943"
```

### Step 7: Deploy to IC Mainnet

⚠️ **MAINNET CHECKLIST:**
- [ ] All local tests passing
- [ ] Cycles wallet has sufficient cycles
- [ ] Identity has correct permissions
- [ ] Backup all canister code
- [ ] Document all canister IDs

```bash
# Switch to mainnet
dfx deploy --network ic --with-cycles 10000000000000

# Or use deployment script
./deploy.sh
```

### Step 8: Post-Deployment Setup

1. **Set Controllers:**
```bash
dfx canister --network ic update-settings lcky_backend \
  --add-controller <MULTISIG_PRINCIPAL>
```

2. **Top up Cycles:**
```bash
dfx canister --network ic deposit-cycles 1000000000000 lcky_backend
```

3. **Set up Monitoring:**
   - Monitor cycle balance
   - Set up alerts for low cycles
   - Monitor transaction volume

## Quick Deploy Scripts

### Ethereum Quick Deploy

```bash
cd LCKY/v2/ethereum
chmod +x deploy.sh
./deploy.sh
```

### ICP Quick Deploy

```bash
cd LCKY/v2/icp
chmod +x deploy.sh
./deploy.sh
```

## Troubleshooting

### Ethereum Issues

**Problem: "insufficient funds"**
```bash
# Check balance
npx hardhat run scripts/check-balance.ts --network <network>

# Get testnet ETH from faucets
```

**Problem: "nonce too low"**
```bash
# Reset account nonce in MetaMask or hardhat
```

**Problem: "contract creation code storage out of gas"**
```bash
# Increase gas limit in hardhat.config.ts
```

### ICP Issues

**Problem: "Replica not running"**
```bash
dfx stop
dfx start --background --clean
```

**Problem: "Out of cycles"**
```bash
# Check cycles
dfx wallet --network ic balance

# Add cycles
dfx wallet --network ic send-cycles <CANISTER_ID> <AMOUNT>
```

**Problem: "Build failed"**
```bash
# Clean build
rm -rf .dfx
dfx cache clean
dfx start --background --clean
```

## Deployment Costs

### Ethereum (approximate)

| Network | Gas Cost | USD Cost* |
|---------|----------|-----------|
| Mainnet | ~3M gas  | $30-150   |
| Polygon | ~3M gas  | $0.10-1   |
| BSC     | ~3M gas  | $0.50-5   |

*Varies with gas prices and ETH price

### ICP (approximate)

| Operation         | Cycles        | USD Cost* |
|-------------------|---------------|-----------|
| Canister Creation | 100B cycles   | ~$0.13    |
| Code Installation | 1B cycles     | ~$0.0013  |
| Monthly Storage   | ~1B cycles    | ~$0.0013  |

*At 1 trillion cycles = $1 USD

## Post-Deployment Checklist

- [ ] Save all contract/canister addresses
- [ ] Verify contracts on block explorers
- [ ] Update frontend with new addresses
- [ ] Test all functions on deployed contracts
- [ ] Set up monitoring and alerts
- [ ] Document deployment in team wiki
- [ ] Announce deployment (if public)
- [ ] Set up multisig for admin functions
- [ ] Transfer ownership from deployer
- [ ] Create backup of deployment artifacts

## Security Post-Deployment

1. **Transfer Ownership:**
   - Ethereum: Transfer to multisig
   - ICP: Add multiple controllers

2. **Renounce Deployer:**
   - After thorough testing
   - Only if appropriate for your use case

3. **Monitor:**
   - Set up event monitoring
   - Track unusual transactions
   - Monitor for exploits

4. **Incident Response Plan:**
   - Pause mechanisms
   - Emergency contacts
   - Communication strategy

## Support

If you encounter issues:

1. Check logs: `npx hardhat node` (Ethereum) or `dfx logs` (ICP)
2. Review documentation
3. Ask in Discord/Telegram
4. Open GitHub issue

## Next Steps

After successful deployment:

1. [Frontend Integration Guide](FRONTEND_INTEGRATION.md)
2. [API Documentation](API_DOCS.md)
3. [User Guide](USER_GUIDE.md)
4. [Admin Panel Setup](ADMIN_GUIDE.md)

---

**Good luck with your deployment! 🪄✨**

