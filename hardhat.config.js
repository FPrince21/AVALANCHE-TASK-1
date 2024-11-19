require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    avalanche: {
      url: process.env.AVALANCHE_RPC_URL,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
    },
  },
};
