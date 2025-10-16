import { ethers } from "hardhat";

async function main() {
  console.log("🪄 Deploying LCKY Token System...\n");

  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());
  console.log("");

  // Deploy main LCKY token
  console.log("📦 Deploying LCKYToken...");
  const LCKYToken = await ethers.getContractFactory("LCKYToken");
  const lckyToken = await LCKYToken.deploy();
  await lckyToken.waitForDeployment();
  const lckyAddress = await lckyToken.getAddress();
  console.log("✅ LCKYToken deployed to:", lckyAddress);
  console.log("");

  // Deploy multi-currency factory
  console.log("📦 Deploying LCKYMultiCurrency...");
  const LCKYMultiCurrency = await ethers.getContractFactory("LCKYMultiCurrency");
  const multiCurrency = await LCKYMultiCurrency.deploy();
  await multiCurrency.waitForDeployment();
  const multiCurrencyAddress = await multiCurrency.getAddress();
  console.log("✅ LCKYMultiCurrency deployed to:", multiCurrencyAddress);
  console.log("");

  // Deploy stable currency tokens
  const stableTokens = [
    { name: "LCKYUSDToken", symbol: "LCKYUSD" },
    { name: "LCKYRUBToken", symbol: "LCKYRUB" },
    { name: "LCKYCNYToken", symbol: "LCKYCNY" },
    { name: "LCKYINRToken", symbol: "LCKYINR" },
    { name: "LCKYTHBToken", symbol: "LCKYTHB" },
    { name: "LCKYUAHToken", symbol: "LCKYUAH" },
  ];

  console.log("📦 Deploying stable currency tokens...");
  const deployedStableTokens: { [key: string]: string } = {};

  for (const token of stableTokens) {
    const TokenFactory = await ethers.getContractFactory(token.name);
    const tokenContract = await TokenFactory.deploy();
    await tokenContract.waitForDeployment();
    const tokenAddress = await tokenContract.getAddress();
    deployedStableTokens[token.symbol] = tokenAddress;
    console.log(`✅ ${token.symbol} deployed to:`, tokenAddress);
  }
  console.log("");

  // Display summary
  console.log("=" .repeat(60));
  console.log("🎉 Deployment Summary");
  console.log("=" .repeat(60));
  console.log("Main Token:");
  console.log(`  LCKY: ${lckyAddress}`);
  console.log("");
  console.log("Multi-Currency Factory:");
  console.log(`  Factory: ${multiCurrencyAddress}`);
  console.log("");
  console.log("Stable Tokens:");
  for (const [symbol, address] of Object.entries(deployedStableTokens)) {
    console.log(`  ${symbol}: ${address}`);
  }
  console.log("=" .repeat(60));
  console.log("");

  // Get initial stats
  console.log("📊 Initial Stats:");
  const stats = await lckyToken.getStats();
  console.log("  Total Supply:", ethers.formatEther(stats[0]), "LCKY");
  console.log("  Total Mined:", ethers.formatEther(stats[1]), "LCKY");
  console.log("  Current Block Reward:", ethers.formatEther(stats[4]), "LCKY");
  console.log("");

  console.log("🔗 Verification commands:");
  console.log(`npx hardhat verify --network <network> ${lckyAddress}`);
  console.log(`npx hardhat verify --network <network> ${multiCurrencyAddress}`);
  for (const [symbol, address] of Object.entries(deployedStableTokens)) {
    console.log(`npx hardhat verify --network <network> ${address}`);
  }
  console.log("");

  // Save deployment info
  const deploymentInfo = {
    network: (await ethers.provider.getNetwork()).name,
    chainId: (await ethers.provider.getNetwork()).chainId.toString(),
    deployer: deployer.address,
    timestamp: new Date().toISOString(),
    contracts: {
      LCKYToken: lckyAddress,
      LCKYMultiCurrency: multiCurrencyAddress,
      ...deployedStableTokens,
    },
  };

  console.log("💾 Deployment info:");
  console.log(JSON.stringify(deploymentInfo, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

