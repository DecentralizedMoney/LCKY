#!/bin/bash

# LCKY ICP Deployment Script

echo "🪄 LCKY - Internet Computer Deployment"
echo "======================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if dfx is installed
if ! command -v dfx &> /dev/null; then
    echo -e "${RED}❌ dfx is not installed. Please install it first.${NC}"
    echo "Visit: https://internetcomputer.org/docs/current/developer-docs/setup/install/"
    exit 1
fi

echo -e "${GREEN}✅ dfx is installed${NC}"

# Check if running
if ! dfx ping &> /dev/null; then
    echo -e "${YELLOW}⚠️  dfx is not running. Starting local replica...${NC}"
    dfx start --background --clean
    sleep 5
else
    echo -e "${GREEN}✅ dfx is running${NC}"
fi

echo ""
echo "📦 Building canisters..."
dfx canister create --all

echo ""
echo "🔨 Compiling Motoko code..."
dfx build

echo ""
echo "🚀 Deploying canisters..."

# Deploy ICRC1 ledger with init args
echo "Deploying ICRC1 Ledger..."
dfx deploy icrc1_ledger_canister --argument '(record {
  token_name = "Lucky Coin";
  token_symbol = "LCKY";
  minting_account = record {
    owner = principal "aaaaa-aa";
  };
  initial_balances = vec {};
  transfer_fee = 10_000;
  metadata = vec {};
  archive_options = record {
    trigger_threshold = 2000;
    num_blocks_to_archive = 1000;
    controller_id = principal "aaaaa-aa";
  };
})' || echo -e "${YELLOW}⚠️  Ledger might already be deployed${NC}"

# Deploy LCKY backend
echo ""
echo "Deploying LCKY Backend..."
dfx deploy lcky_backend

# Deploy payment backend
echo ""
echo "Deploying Payment Backend..."
dfx deploy payment_backend

# Deploy frontend
echo ""
echo "Deploying Frontend..."
dfx deploy lcky_frontend

echo ""
echo "======================================="
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo "======================================="

# Get canister IDs
echo ""
echo "📋 Canister IDs:"
echo "----------------"
dfx canister id lcky_backend
dfx canister id payment_backend
dfx canister id lcky_frontend

echo ""
echo "🌐 Frontend URL:"
echo "----------------"
FRONTEND_ID=$(dfx canister id lcky_frontend)
echo "http://${FRONTEND_ID}.localhost:4943"

echo ""
echo "💡 Useful commands:"
echo "-------------------"
echo "dfx canister call lcky_backend getStats '()'"
echo "dfx canister call lcky_backend claimInitial '()'"
echo "dfx canister call payment_backend getStats '()'"

echo ""
echo "🛑 To stop the local replica:"
echo "dfx stop"

echo ""
echo -e "${GREEN}✅ Setup complete! Happy coding! 🪄${NC}"

