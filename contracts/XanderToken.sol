// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract XanderToken is ERC20, ERC20Permit {
    constructor() ERC20("XanderToken", "FTK") ERC20Permit("XanderToken") {
        // Mint initial tokens to the deployer's address
        _mint(msg.sender, 1000000 * (10 ** decimals()));
    }
}
