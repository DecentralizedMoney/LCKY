import { ethers } from "hardhat";

/**
 * Interactive script to test LCKY Token functions
 */
async function main() {
  console.log("🪄 LCKY Token Interaction Script\n");

  const [deployer, user1] = await ethers.getSigners();
  
  // Get contract address from command line or use default
  const contractAddress = process.env.CONTRACT_ADDRESS || "";
  
  if (!contractAddress) {
    console.error("❌ Please set CONTRACT_ADDRESS environment variable");
    console.log("Example: CONTRACT_ADDRESS=0x... npx hardhat run scripts/interact.ts --network localhost");
    process.exit(1);
  }

  console.log("📋 Contract Address:", contractAddress);
  console.log("👤 Deployer:", deployer.address);
  console.log("👤 User1:", user1.address);
  console.log("");

  // Get contract instance
  const LCKYToken = await ethers.getContractAt("LCKYToken", contractAddress);

  // Display token info
  console.log("═".repeat(60));
  console.log("TOKEN INFORMATION");
  console.log("═".repeat(60));
  
  const name = await LCKYToken.name();
  const symbol = await LCKYToken.symbol();
  const decimals = await LCKYToken.decimals();
  
  console.log(`Name: ${name}`);
  console.log(`Symbol: ${symbol}`);
  console.log(`Decimals: ${decimals}`);
  console.log("");

  // Get statistics
  console.log("═".repeat(60));
  console.log("STATISTICS");
  console.log("═".repeat(60));
  
  const stats = await LCKYToken.getStats();
  console.log(`Total Supply: ${ethers.formatEther(stats[0])} LCKY`);
  console.log(`Total Mined: ${ethers.formatEther(stats[1])} LCKY`);
  console.log(`Total Donated: ${ethers.formatEther(stats[2])} LCKY`);
  console.log(`Total ETH Donated: ${ethers.formatEther(stats[3])} ETH`);
  console.log(`Current Block Reward: ${ethers.formatEther(stats[4])} LCKY`);
  console.log(`Contract ETH Balance: ${ethers.formatEther(stats[5])} ETH`);
  console.log(`Donation Count: ${stats[6]}`);
  console.log("");

  // Get user info
  console.log("═".repeat(60));
  console.log("USER INFORMATION");
  console.log("═".repeat(60));
  
  const userInfo = await LCKYToken.getUserInfo(deployer.address);
  console.log(`Balance: ${ethers.formatEther(userInfo[0])} LCKY`);
  console.log(`Mined: ${ethers.formatEther(userInfo[1])} LCKY`);
  console.log(`Last Claim Block: ${userInfo[2]}`);
  console.log(`Claimed Initial: ${userInfo[3]}`);
  console.log(`Can Claim: ${userInfo[4]}`);
  console.log("");

  // Interactive menu
  console.log("═".repeat(60));
  console.log("AVAILABLE ACTIONS");
  console.log("═".repeat(60));
  console.log("1. Claim Initial (1000 LCKY)");
  console.log("2. Claim Daily Reward");
  console.log("3. Donate LCKY with Message");
  console.log("4. Donate ETH for LCKY");
  console.log("5. View Donation Messages");
  console.log("6. Emergency SOS");
  console.log("7. Transfer LCKY");
  console.log("");

  // Example: Claim initial
  if (!userInfo[3]) { // If not claimed initial
    console.log("🎁 Claiming initial 1000 LCKY...");
    try {
      const tx = await LCKYToken.claimInitial();
      await tx.wait();
      console.log("✅ Successfully claimed 1000 LCKY!");
      console.log("TX:", tx.hash);
    } catch (error: any) {
      console.log("❌ Error:", error.message);
    }
    console.log("");
  }

  // Example: Check donation messages
  const msgCount = await LCKYToken.getDonationMessagesCount();
  if (msgCount > 0n) {
    console.log("═".repeat(60));
    console.log(`DONATION MESSAGES (${msgCount} total)`);
    console.log("═".repeat(60));
    
    const messages = await LCKYToken.getDonationMessages(0, 5);
    messages.forEach((msg: any, i: number) => {
      console.log(`\n${i + 1}. From: ${msg.donor}`);
      console.log(`   Amount: ${ethers.formatEther(msg.amount)} LCKY`);
      console.log(`   Message: ${msg.message}`);
      console.log(`   Time: ${new Date(Number(msg.timestamp) * 1000).toLocaleString()}`);
    });
    console.log("");
  }

  console.log("═".repeat(60));
  console.log("✅ Interaction complete!");
  console.log("═".repeat(60));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

