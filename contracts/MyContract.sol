// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";  // Import Ownable contract
import "./XanderToken.sol";  // Import the XanderToken contract

// AssetManager contract to handle deposits and rewards
contract AssetManager is Ownable {
    XanderToken public token;  // Reference to the XanderToken contract

    uint public rewardPool = 10000 * (10 ** 18); // 10,000 tokens in the reward pool
    uint public assetRewardRate = 0.1 * (10 ** 18); // 0.1 token reward per asset per day
    uint public tokenPerAsset = 10 * (10 ** 18); // 10 tokens required per asset

    struct AssetHolder {
        uint assets;  // Number of assets the user holds
        uint lastClaim;  // Timestamp of when they last claimed rewards
    }

    mapping(address => AssetHolder) public assetHolders;

    // Constructor to initialize the token address and call the Ownable constructor with msg.sender
    constructor(address tokenAddress) Ownable(msg.sender) {
        token = XanderToken(tokenAddress);  // Initialize with the deployed XanderToken contract
    }

    // Deposit tokens to create assets
    function depositTokens(uint amount) public {
        require(amount % tokenPerAsset == 0, "Deposit must be multiple of 10 tokens.");
        uint assetCount = amount / tokenPerAsset;  // 1 asset per 10 tokens

        token.transferFrom(msg.sender, address(this), amount);  // Transfer tokens to the contract

        AssetHolder storage holder = assetHolders[msg.sender];
        holder.assets += assetCount;  // Increase the user's assets
        if (holder.lastClaim == 0) {
            holder.lastClaim = block.timestamp;  // Set the last claim time if it's the first deposit
        }
    }

    // Claim rewards based on the number of assets
    function claimRewards() public {
        AssetHolder storage holder = assetHolders[msg.sender];
        require(holder.assets > 0, "No assets to claim rewards for.");

        uint daysElapsed = (block.timestamp - holder.lastClaim) / 1 days;  // Calculate how many days have passed
        require(daysElapsed > 0, "You must wait at least one day to claim rewards.");

        uint reward = daysElapsed * holder.assets * assetRewardRate;  // Calculate reward based on assets
        require(reward <= rewardPool, "Not enough reward in the pool.");  // Ensure enough reward is available

        holder.lastClaim = block.timestamp;  // Update the last claim time
        rewardPool -= reward;  // Deduct from the reward pool

        token.transfer(msg.sender, reward);  // Transfer the reward to the user
    }
}

