// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title LCKYToken
 * @dev LCKY - Lucky Coin with advanced features
 * 
 * Features:
 * - Mining with halving every 4 years
 * - Donation with burning and messages
 * - ETH donation to get LCKY
 * - Emergency SOS function
 * - Multi-currency support
 */
contract LCKYToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard, Pausable {
    
    // Constants
    uint256 public constant MAX_SUPPLY = 108_000_000_000 * 10**18; // 108 billion
    uint256 public constant INITIAL_REWARD = 50 * 10**18; // 50 LCKY per block
    uint256 public constant HALVING_INTERVAL = 2_102_400; // ~4 years (assuming 15s block time)
    uint256 public constant MIN_DONATION_ETH = 0.001 ether;
    uint256 public constant MIN_CLAIM_INTERVAL = 1 days; // Can claim once per day
    
    // State variables
    uint256 public deploymentBlock;
    uint256 public totalMined;
    uint256 public totalDonated;
    uint256 public totalETHDonated;
    
    // Mappings
    mapping(address => uint256) public lastClaimBlock;
    mapping(address => uint256) public userMined;
    mapping(address => bool) public hasClaimedInitial;
    
    // Donation tracking
    struct DonationMessage {
        address donor;
        uint256 amount;
        string message;
        uint256 timestamp;
    }
    
    DonationMessage[] public donationMessages;
    
    // Events
    event Claimed(address indexed user, uint256 amount, uint256 blockNumber);
    event DonationWithMessage(address indexed donor, uint256 amount, string message);
    event ETHDonated(address indexed donor, uint256 ethAmount, uint256 lckyReceived);
    event EmergencySOS(address indexed user, uint256 lckyBurned, uint256 ethReceived);
    event TokenURIUpdated(string newURI);
    
    // Token metadata
    string private _tokenURI;
    
    /**
     * @dev Constructor
     * Initial supply is minted to contract for distribution
     */
    constructor() ERC20("Lucky Coin", "LCKY") Ownable(msg.sender) {
        deploymentBlock = block.number;
        _tokenURI = "https://assets.lckycoin.com/lckycoin.json";
        
        // Mint initial supply for team and liquidity (5%)
        uint256 initialMint = (MAX_SUPPLY * 5) / 100;
        _mint(msg.sender, initialMint);
    }
    
    /**
     * @dev Get current block reward based on halving schedule
     */
    function getCurrentBlockReward() public view returns (uint256) {
        if (totalMined >= MAX_SUPPLY) {
            return 0;
        }
        
        uint256 blocksSinceDeployment = block.number - deploymentBlock;
        uint256 halvings = blocksSinceDeployment / HALVING_INTERVAL;
        
        // Maximum 20 halvings (after that reward is essentially 0)
        if (halvings >= 20) {
            return 0;
        }
        
        uint256 reward = INITIAL_REWARD >> halvings; // Divide by 2^halvings
        
        // Check if we would exceed max supply
        if (totalMined + reward > MAX_SUPPLY) {
            return MAX_SUPPLY - totalMined;
        }
        
        return reward;
    }
    
    /**
     * @dev Claim LCKY tokens (mining/claiming mechanism)
     */
    function claim() external nonReentrant whenNotPaused returns (uint256) {
        require(
            block.number >= lastClaimBlock[msg.sender] + 6400, // ~1 day worth of blocks
            "Claim too soon"
        );
        
        uint256 reward = getCurrentBlockReward();
        require(reward > 0, "No more rewards available");
        require(totalMined + reward <= MAX_SUPPLY, "Max supply reached");
        
        lastClaimBlock[msg.sender] = block.number;
        userMined[msg.sender] += reward;
        totalMined += reward;
        
        _mint(msg.sender, reward);
        
        emit Claimed(msg.sender, reward, block.number);
        return reward;
    }
    
    /**
     * @dev Initial claim for new users (one-time)
     */
    function claimInitial() external nonReentrant whenNotPaused returns (uint256) {
        require(!hasClaimedInitial[msg.sender], "Already claimed initial amount");
        
        uint256 initialAmount = 1000 * 10**18; // 1000 LCKY
        require(totalMined + initialAmount <= MAX_SUPPLY, "Max supply reached");
        
        hasClaimedInitial[msg.sender] = true;
        totalMined += initialAmount;
        userMined[msg.sender] += initialAmount;
        
        _mint(msg.sender, initialAmount);
        
        emit Claimed(msg.sender, initialAmount, block.number);
        return initialAmount;
    }
    
    /**
     * @dev Donate LCKY by burning with a message
     * @param amount Amount of LCKY to burn
     * @param message Message to store in blockchain
     */
    function donateWithMessage(uint256 amount, string memory message) external nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be > 0");
        require(bytes(message).length <= 280, "Message too long"); // Twitter-style limit
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        _burn(msg.sender, amount);
        totalDonated += amount;
        
        donationMessages.push(DonationMessage({
            donor: msg.sender,
            amount: amount,
            message: message,
            timestamp: block.timestamp
        }));
        
        emit DonationWithMessage(msg.sender, amount, message);
    }
    
    /**
     * @dev Donate ETH to get LCKY tokens
     * Exchange rate based on contract's ETH balance and total supply
     */
    function donateETH() external payable nonReentrant whenNotPaused returns (uint256) {
        require(msg.value >= MIN_DONATION_ETH, "Donation too small");
        
        // Calculate LCKY to mint based on ETH donated
        // Rate: 1 ETH = 10,000 LCKY (can be adjusted by owner)
        uint256 lckyAmount = (msg.value * 10000 * 10**18) / 1 ether;
        
        require(totalMined + lckyAmount <= MAX_SUPPLY, "Would exceed max supply");
        
        totalMined += lckyAmount;
        totalETHDonated += msg.value;
        
        _mint(msg.sender, lckyAmount);
        
        emit ETHDonated(msg.sender, msg.value, lckyAmount);
        return lckyAmount;
    }
    
    /**
     * @dev Emergency SOS - burn LCKY to get ETH proportionally
     * User gets ETH proportional to their LCKY vs total supply
     */
    function emergencySOS() external nonReentrant whenNotPaused returns (uint256) {
        uint256 userBalance = balanceOf(msg.sender);
        require(userBalance > 0, "No LCKY balance");
        
        uint256 contractETHBalance = address(this).balance;
        require(contractETHBalance > 0, "No ETH in contract");
        
        uint256 supply = totalSupply();
        require(supply > 0, "No supply");
        
        // Calculate proportional ETH
        uint256 ethToReturn = (userBalance * contractETHBalance) / supply;
        require(ethToReturn > 0, "ETH amount too small");
        require(ethToReturn <= contractETHBalance, "Insufficient contract balance");
        
        // Burn user's LCKY
        _burn(msg.sender, userBalance);
        
        // Send ETH
        (bool success, ) = msg.sender.call{value: ethToReturn}("");
        require(success, "ETH transfer failed");
        
        emit EmergencySOS(msg.sender, userBalance, ethToReturn);
        return ethToReturn;
    }
    
    /**
     * @dev Get total number of donation messages
     */
    function getDonationMessagesCount() external view returns (uint256) {
        return donationMessages.length;
    }
    
    /**
     * @dev Get donation messages with pagination
     * @param offset Starting index
     * @param limit Number of messages to return
     */
    function getDonationMessages(uint256 offset, uint256 limit) 
        external 
        view 
        returns (DonationMessage[] memory) 
    {
        require(offset < donationMessages.length, "Offset out of bounds");
        
        uint256 end = offset + limit;
        if (end > donationMessages.length) {
            end = donationMessages.length;
        }
        
        uint256 size = end - offset;
        DonationMessage[] memory messages = new DonationMessage[](size);
        
        for (uint256 i = 0; i < size; i++) {
            messages[i] = donationMessages[offset + i];
        }
        
        return messages;
    }
    
    /**
     * @dev Get statistics
     */
    function getStats() external view returns (
        uint256 _totalSupply,
        uint256 _totalMined,
        uint256 _totalDonated,
        uint256 _totalETHDonated,
        uint256 _currentBlockReward,
        uint256 _contractETHBalance,
        uint256 _donationCount
    ) {
        return (
            totalSupply(),
            totalMined,
            totalDonated,
            totalETHDonated,
            getCurrentBlockReward(),
            address(this).balance,
            donationMessages.length
        );
    }
    
    /**
     * @dev Get user info
     */
    function getUserInfo(address user) external view returns (
        uint256 balance,
        uint256 mined,
        uint256 lastClaim,
        bool claimedInitial,
        bool canClaim
    ) {
        return (
            balanceOf(user),
            userMined[user],
            lastClaimBlock[user],
            hasClaimedInitial[user],
            block.number >= lastClaimBlock[user] + 6400
        );
    }
    
    // Token URI functions
    function tokenURI() external view returns (string memory) {
        return _tokenURI;
    }
    
    function setTokenURI(string memory newURI) external onlyOwner {
        _tokenURI = newURI;
        emit TokenURIUpdated(newURI);
    }
    
    // Admin functions
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev Emergency withdraw (only owner, for rescue purposes)
     */
    function emergencyWithdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        (bool success, ) = owner().call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    /**
     * @dev Receive ETH
     */
    receive() external payable {
        totalETHDonated += msg.value;
        emit ETHDonated(msg.sender, msg.value, 0);
    }
}

