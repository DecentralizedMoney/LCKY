#!/bin/bash

# LCKY ICP Test Script

echo "🧪 Testing LCKY Canisters"
echo "========================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get current identity
PRINCIPAL=$(dfx identity get-principal)
echo -e "${GREEN}Current Identity:${NC} $PRINCIPAL"
echo ""

# Test lcky_backend
echo "Testing lcky_backend..."
echo "----------------------"

echo "1. Get token info:"
dfx canister call lcky_backend name '()'
dfx canister call lcky_backend symbol '()'
dfx canister call lcky_backend decimals '()'
echo ""

echo "2. Get statistics:"
dfx canister call lcky_backend getStats '()'
echo ""

echo "3. Check balance:"
dfx canister call lcky_backend balanceOf "(principal \"$PRINCIPAL\")"
echo ""

echo "4. Claim initial tokens:"
dfx canister call lcky_backend claimInitial '()'
echo ""

echo "5. Check balance after claim:"
dfx canister call lcky_backend balanceOf "(principal \"$PRINCIPAL\")"
echo ""

echo "6. Get user info:"
dfx canister call lcky_backend getUserInfo "(principal \"$PRINCIPAL\")"
echo ""

echo "7. Try regular claim (should fail - too soon):"
dfx canister call lcky_backend claim '()' || echo -e "${YELLOW}Expected error: Claim too soon${NC}"
echo ""

# Test payment_backend
echo "Testing payment_backend..."
echo "--------------------------"

echo "1. Get exchange rate:"
dfx canister call payment_backend getExchangeRate '()'
echo ""

echo "2. Get minimum payment:"
dfx canister call payment_backend getMinimumPayment '()'
echo ""

echo "3. Calculate LCKY amount for 1 ICP:"
dfx canister call payment_backend calculateLCKYAmount '(100_000_000)'
echo ""

echo "4. Get payment stats:"
dfx canister call payment_backend getStats '()'
echo ""

echo "5. Health check:"
dfx canister call payment_backend healthCheck '()'
echo ""

# Test donation
echo "Testing donation..."
echo "-------------------"

echo "1. Donate with message:"
dfx canister call lcky_backend donateWithMessage '(100_000_000_000_000_000_000, "Test donation from script!")' || echo -e "${YELLOW}Note: Donation might fail if insufficient balance${NC}"
echo ""

echo "2. Get donation messages:"
dfx canister call lcky_backend getDonationMessages '(0, 10)'
echo ""

echo "3. Get donation count:"
dfx canister call lcky_backend getDonationMessagesCount '()'
echo ""

# Summary
echo "========================="
echo -e "${GREEN}✅ Testing Complete!${NC}"
echo "========================="

echo ""
echo "Canister IDs:"
echo "-------------"
echo "lcky_backend: $(dfx canister id lcky_backend)"
echo "payment_backend: $(dfx canister id payment_backend)"
echo "lcky_frontend: $(dfx canister id lcky_frontend)"

echo ""
echo "Frontend URL:"
echo "-------------"
FRONTEND_ID=$(dfx canister id lcky_frontend)
echo "http://${FRONTEND_ID}.localhost:4943"

