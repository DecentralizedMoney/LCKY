// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./LCKYToken.sol";

/**
 * @title LCKYMultiCurrency
 * @dev Factory contract for creating LCKY tokens for different currencies
 */
contract LCKYMultiCurrency {
    
    struct CurrencyToken {
        address tokenAddress;
        string currencyCode;
        string name;
        string symbol;
        uint256 deploymentTime;
    }
    
    mapping(string => CurrencyToken) public currencies;
    string[] public currencyList;
    address public immutable owner;
    
    event CurrencyTokenDeployed(
        string currencyCode,
        address tokenAddress,
        string name,
        string symbol
    );
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    /**
     * @dev Deploy a new LCKY token for a specific currency
     */
    function deployCurrencyToken(
        string memory currencyCode,
        string memory name,
        string memory symbol
    ) external onlyOwner returns (address) {
        require(currencies[currencyCode].tokenAddress == address(0), "Currency already exists");
        require(bytes(currencyCode).length > 0, "Invalid currency code");
        require(bytes(name).length > 0, "Invalid name");
        require(bytes(symbol).length > 0, "Invalid symbol");
        
        // Note: This is a simplified version. In production, you'd want to deploy
        // a separate contract with the specific name/symbol
        
        currencies[currencyCode] = CurrencyToken({
            tokenAddress: address(0), // Placeholder
            currencyCode: currencyCode,
            name: name,
            symbol: symbol,
            deploymentTime: block.timestamp
        });
        
        currencyList.push(currencyCode);
        
        emit CurrencyTokenDeployed(currencyCode, address(0), name, symbol);
        
        return address(0);
    }
    
    /**
     * @dev Get all supported currencies
     */
    function getSupportedCurrencies() external view returns (string[] memory) {
        return currencyList;
    }
    
    /**
     * @dev Get currency token info
     */
    function getCurrencyInfo(string memory currencyCode) 
        external 
        view 
        returns (CurrencyToken memory) 
    {
        return currencies[currencyCode];
    }
}

/**
 * @title LCKYStableCurrency
 * @dev Base contract for LCKY tokens tied to fiat currencies
 * These tokens maintain a peg to specific currencies through oracle integration
 */
contract LCKYStableCurrency is ERC20, Ownable {
    
    string private _tokenURI;
    string public currencyCode;
    
    // Oracle for price feeds (simplified)
    address public priceOracle;
    
    event TokenURIUpdated(string newURI);
    event OracleUpdated(address newOracle);
    
    constructor(
        string memory name,
        string memory symbol,
        string memory _currencyCode
    ) ERC20(name, symbol) Ownable(msg.sender) {
        currencyCode = _currencyCode;
        _tokenURI = string(abi.encodePacked("https://assets.lckycoin.com/lcky", _currencyCode, ".json"));
        
        // Mint initial supply
        _mint(msg.sender, 108_000_000_000 * 10**18);
    }
    
    function tokenURI() external view returns (string memory) {
        return _tokenURI;
    }
    
    function setTokenURI(string memory newURI) external onlyOwner {
        _tokenURI = newURI;
        emit TokenURIUpdated(newURI);
    }
    
    function setOracle(address _oracle) external onlyOwner {
        priceOracle = _oracle;
        emit OracleUpdated(_oracle);
    }
}

// Specific currency implementations
contract LCKYUSDToken is LCKYStableCurrency {
    constructor() LCKYStableCurrency("Lucky Coin USD", "LCKYUSD", "USD") {}
}

contract LCKYRUBToken is LCKYStableCurrency {
    constructor() LCKYStableCurrency("Lucky Coin RUB", "LCKYRUB", "RUB") {}
}

contract LCKYCNYToken is LCKYStableCurrency {
    constructor() LCKYStableCurrency("Lucky Coin CNY", "LCKYCNY", "CNY") {}
}

contract LCKYINRToken is LCKYStableCurrency {
    constructor() LCKYStableCurrency("Lucky Coin INR", "LCKYINR", "INR") {}
}

contract LCKYTHBToken is LCKYStableCurrency {
    constructor() LCKYStableCurrency("Lucky Coin THB", "LCKYTHB", "THB") {}
}

contract LCKYUAHToken is LCKYStableCurrency {
    constructor() LCKYStableCurrency("Lucky Coin UAH", "LCKYUAH", "UAH") {}
}

