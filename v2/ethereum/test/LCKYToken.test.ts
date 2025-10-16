import { expect } from "chai";
import { ethers } from "hardhat";
import { LCKYToken } from "../typechain-types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

describe("LCKYToken", function () {
  let lckyToken: LCKYToken;
  let owner: HardhatEthersSigner;
  let user1: HardhatEthersSigner;
  let user2: HardhatEthersSigner;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();

    const LCKYToken = await ethers.getContractFactory("LCKYToken");
    lckyToken = await LCKYToken.deploy();
    await lckyToken.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await lckyToken.owner()).to.equal(owner.address);
    });

    it("Should have correct name and symbol", async function () {
      expect(await lckyToken.name()).to.equal("Lucky Coin");
      expect(await lckyToken.symbol()).to.equal("LCKY");
    });

    it("Should mint initial supply to owner", async function () {
      const maxSupply = await lckyToken.MAX_SUPPLY();
      const expectedInitial = maxSupply * BigInt(5) / BigInt(100); // 5%
      expect(await lckyToken.balanceOf(owner.address)).to.equal(expectedInitial);
    });

    it("Should set correct constants", async function () {
      expect(await lckyToken.MAX_SUPPLY()).to.equal(ethers.parseEther("108000000000"));
      expect(await lckyToken.INITIAL_REWARD()).to.equal(ethers.parseEther("50"));
    });
  });

  describe("Claiming", function () {
    it("Should allow initial claim for new users", async function () {
      const tx = await lckyToken.connect(user1).claimInitial();
      await tx.wait();

      const expectedAmount = ethers.parseEther("1000");
      expect(await lckyToken.balanceOf(user1.address)).to.equal(expectedAmount);
      expect(await lckyToken.hasClaimedInitial(user1.address)).to.be.true;
    });

    it("Should not allow claiming initial twice", async function () {
      await lckyToken.connect(user1).claimInitial();
      await expect(
        lckyToken.connect(user1).claimInitial()
      ).to.be.revertedWith("Already claimed initial amount");
    });

    it("Should calculate correct block reward", async function () {
      const reward = await lckyToken.getCurrentBlockReward();
      expect(reward).to.equal(ethers.parseEther("50"));
    });

    it("Should not allow claiming too soon", async function () {
      await lckyToken.connect(user1).claimInitial();
      
      await expect(
        lckyToken.connect(user1).claim()
      ).to.be.revertedWith("Claim too soon");
    });
  });

  describe("Donation with Message", function () {
    beforeEach(async function () {
      // Give user1 some tokens first
      await lckyToken.connect(user1).claimInitial();
    });

    it("Should allow donation with message", async function () {
      const amount = ethers.parseEther("100");
      const message = "For the temple!";

      const tx = await lckyToken.connect(user1).donateWithMessage(amount, message);
      await tx.wait();

      const donations = await lckyToken.getDonationMessages(0, 10);
      expect(donations.length).to.equal(1);
      expect(donations[0].donor).to.equal(user1.address);
      expect(donations[0].amount).to.equal(amount);
      expect(donations[0].message).to.equal(message);
    });

    it("Should burn tokens when donating", async function () {
      const initialBalance = await lckyToken.balanceOf(user1.address);
      const amount = ethers.parseEther("100");

      await lckyToken.connect(user1).donateWithMessage(amount, "Test donation");

      const finalBalance = await lckyToken.balanceOf(user1.address);
      expect(finalBalance).to.equal(initialBalance - amount);
    });

    it("Should not allow message longer than 280 characters", async function () {
      const amount = ethers.parseEther("100");
      const longMessage = "a".repeat(281);

      await expect(
        lckyToken.connect(user1).donateWithMessage(amount, longMessage)
      ).to.be.revertedWith("Message too long");
    });

    it("Should not allow donation without sufficient balance", async function () {
      const amount = ethers.parseEther("10000");
      await expect(
        lckyToken.connect(user1).donateWithMessage(amount, "Test")
      ).to.be.revertedWith("Insufficient balance");
    });
  });

  describe("ETH Donation", function () {
    it("Should accept ETH and mint LCKY", async function () {
      const ethAmount = ethers.parseEther("1");
      const expectedLCKY = ethAmount * BigInt(10000); // 1 ETH = 10,000 LCKY

      const tx = await lckyToken.connect(user1).donateETH({ value: ethAmount });
      await tx.wait();

      expect(await lckyToken.balanceOf(user1.address)).to.equal(expectedLCKY);
      expect(await ethers.provider.getBalance(await lckyToken.getAddress())).to.equal(ethAmount);
    });

    it("Should not accept donation below minimum", async function () {
      const tooSmall = ethers.parseEther("0.0001");
      await expect(
        lckyToken.connect(user1).donateETH({ value: tooSmall })
      ).to.be.revertedWith("Donation too small");
    });

    it("Should track total ETH donated", async function () {
      const ethAmount = ethers.parseEther("1");
      await lckyToken.connect(user1).donateETH({ value: ethAmount });

      const stats = await lckyToken.getStats();
      expect(stats[3]).to.equal(ethAmount); // totalETHDonated
    });
  });

  describe("Emergency SOS", function () {
    beforeEach(async function () {
      // Add ETH to contract
      await lckyToken.connect(user1).donateETH({ value: ethers.parseEther("10") });
      
      // Give user2 some tokens
      await lckyToken.connect(user2).claimInitial();
    });

    it("Should allow SOS withdrawal", async function () {
      const user2Balance = await lckyToken.balanceOf(user2.address);
      const totalSupply = await lckyToken.totalSupply();
      const contractETH = await ethers.provider.getBalance(await lckyToken.getAddress());

      const expectedETH = (user2Balance * contractETH) / totalSupply;

      const initialETHBalance = await ethers.provider.getBalance(user2.address);
      const tx = await lckyToken.connect(user2).emergencySOS();
      const receipt = await tx.wait();
      const gasUsed = receipt!.gasUsed * receipt!.gasPrice;

      const finalETHBalance = await ethers.provider.getBalance(user2.address);
      const ethReceived = finalETHBalance - initialETHBalance + gasUsed;

      // Allow for small rounding differences
      expect(ethReceived).to.be.closeTo(expectedETH, ethers.parseEther("0.0001"));
      expect(await lckyToken.balanceOf(user2.address)).to.equal(0);
    });

    it("Should not allow SOS without balance", async function () {
      const user3 = (await ethers.getSigners())[3];
      await expect(
        lckyToken.connect(user3).emergencySOS()
      ).to.be.revertedWith("No LCKY balance");
    });
  });

  describe("Statistics and User Info", function () {
    it("Should return correct stats", async function () {
      const stats = await lckyToken.getStats();
      expect(stats[0]).to.be.gt(0); // totalSupply
      expect(stats[4]).to.equal(ethers.parseEther("50")); // currentBlockReward
    });

    it("Should return correct user info", async function () {
      await lckyToken.connect(user1).claimInitial();
      
      const userInfo = await lckyToken.getUserInfo(user1.address);
      expect(userInfo[0]).to.equal(ethers.parseEther("1000")); // balance
      expect(userInfo[1]).to.equal(ethers.parseEther("1000")); // mined
      expect(userInfo[3]).to.be.true; // claimedInitial
    });
  });

  describe("Admin Functions", function () {
    it("Should allow owner to pause", async function () {
      await lckyToken.pause();
      await expect(
        lckyToken.connect(user1).claimInitial()
      ).to.be.reverted;
    });

    it("Should allow owner to unpause", async function () {
      await lckyToken.pause();
      await lckyToken.unpause();
      await lckyToken.connect(user1).claimInitial();
      expect(await lckyToken.balanceOf(user1.address)).to.be.gt(0);
    });

    it("Should not allow non-owner to pause", async function () {
      await expect(
        lckyToken.connect(user1).pause()
      ).to.be.reverted;
    });

    it("Should allow owner to update token URI", async function () {
      const newURI = "https://new-uri.com/token.json";
      await lckyToken.setTokenURI(newURI);
      expect(await lckyToken.tokenURI()).to.equal(newURI);
    });

    it("Should allow owner emergency withdraw", async function () {
      // Add ETH to contract
      await lckyToken.connect(user1).donateETH({ value: ethers.parseEther("5") });

      const contractBalance = await ethers.provider.getBalance(await lckyToken.getAddress());
      const ownerInitialBalance = await ethers.provider.getBalance(owner.address);

      const tx = await lckyToken.emergencyWithdraw(ethers.parseEther("2"));
      const receipt = await tx.wait();
      const gasUsed = receipt!.gasUsed * receipt!.gasPrice;

      const ownerFinalBalance = await ethers.provider.getBalance(owner.address);
      const received = ownerFinalBalance - ownerInitialBalance + gasUsed;

      expect(received).to.equal(ethers.parseEther("2"));
    });
  });

  describe("Receive Function", function () {
    it("Should accept direct ETH transfers", async function () {
      const ethAmount = ethers.parseEther("1");
      await user1.sendTransaction({
        to: await lckyToken.getAddress(),
        value: ethAmount,
      });

      const contractBalance = await ethers.provider.getBalance(await lckyToken.getAddress());
      expect(contractBalance).to.equal(ethAmount);
    });
  });
});

