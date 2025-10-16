#!/bin/bash

# LCKY Ethereum Deployment Script

echo "🪄 LCKY - Ethereum Deployment"
echo "=============================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}⚠️  node_modules not found. Installing dependencies...${NC}"
    npm install
fi

echo -e "${GREEN}✅ Dependencies installed${NC}"

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Please create it from .env.example${NC}"
    echo "cp .env.example .env"
    exit 1
fi

echo -e "${GREEN}✅ .env file found${NC}"

# Menu
echo ""
echo "Select deployment target:"
echo "1) Local (Hardhat Node)"
echo "2) Sepolia Testnet"
echo "3) Ethereum Mainnet"
echo "4) Polygon"
echo "5) BSC"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        NETWORK="localhost"
        echo -e "${BLUE}🏠 Deploying to Local Hardhat Node${NC}"
        
        # Check if local node is running
        if ! nc -z localhost 8545 2>/dev/null; then
            echo -e "${YELLOW}⚠️  Local node not running. Starting...${NC}"
            npx hardhat node &
            NODE_PID=$!
            sleep 5
            STOP_NODE=true
        fi
        ;;
    2)
        NETWORK="sepolia"
        echo -e "${BLUE}🧪 Deploying to Sepolia Testnet${NC}"
        ;;
    3)
        NETWORK="mainnet"
        echo -e "${RED}⚠️  WARNING: Deploying to MAINNET${NC}"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            echo "Deployment cancelled"
            exit 0
        fi
        ;;
    4)
        NETWORK="polygon"
        echo -e "${BLUE}🟣 Deploying to Polygon${NC}"
        ;;
    5)
        NETWORK="bsc"
        echo -e "${YELLOW}🟡 Deploying to BSC${NC}"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "🔨 Compiling contracts..."
npx hardhat compile

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Compilation failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Compilation successful${NC}"

echo ""
echo "🧪 Running tests..."
npx hardhat test

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Tests failed${NC}"
    read -p "Continue anyway? (yes/no): " continue_test
    if [ "$continue_test" != "yes" ]; then
        exit 1
    fi
fi

echo ""
echo "🚀 Deploying to $NETWORK..."
npx hardhat run scripts/deploy.ts --network $NETWORK

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi

echo ""
echo "=============================="
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo "=============================="

# Stop local node if we started it
if [ "$STOP_NODE" = true ]; then
    echo ""
    read -p "Stop local node? (yes/no): " stop
    if [ "$stop" = "yes" ]; then
        kill $NODE_PID
        echo -e "${GREEN}✅ Local node stopped${NC}"
    else
        echo -e "${YELLOW}⚠️  Local node still running (PID: $NODE_PID)${NC}"
    fi
fi

echo ""
echo "💡 Next steps:"
echo "-------------"
echo "1. Save the contract addresses"
echo "2. Verify contracts on Etherscan (if on testnet/mainnet)"
echo "3. Update frontend with new addresses"
echo "4. Test all functions"

echo ""
echo -e "${GREEN}✅ All done! Happy coding! 🪄${NC}"

