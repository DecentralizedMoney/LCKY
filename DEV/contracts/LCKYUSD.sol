// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LCKYUSDToken is ERC20 {
    string private _tokenURI;

    constructor() ERC20("Lucky USD", "LCKYUSD") {
        _mint(msg.sender, 108000000000 * 10 ** decimals());
        _setTokenURI("https://assets.lckycoin.com/lckyusd.json");
    }


    function tokenURI(uint256) public view returns (string memory) {
        return _tokenURI;
    }

    function _setTokenURI(string memory myTokenURI) internal {
        _tokenURI = myTokenURI;
    }
}