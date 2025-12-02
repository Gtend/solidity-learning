import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ignition";

const PRIVATE_KEY =
  "Private Key is Secret. Please Replace This String With Your Own Private Key.";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    kairos: {
      url: "https://public-en-kairos.node.kaia.io",
      chainId: 1001,
      accounts: [PRIVATE_KEY],
    },
  },
};

export default config;
