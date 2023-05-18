/** @type import('hardhat/config').HardhatUserConfig */
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-truffle5");
require("@nomiclabs/hardhat-etherscan");
const { etherscanApiKey,alchemyApiKey, mnemonic,GOERLI_PRIVATE_KEY } = require('./secrets.json');

module.exports = {
  networks: {
   rinkeby: {
     url: `https://eth-rinkeby.alchemyapi.io/v2/${alchemyApiKey}`,
     accounts: { mnemonic: mnemonic },
     gas: 2100000,
     gasPrice: 8000000000,
     saveDeployments: true,
         },
         goerli: {
          url: `https://eth-goerli.alchemyapi.io/v2/${alchemyApiKey}`,
          accounts: [GOERLI_PRIVATE_KEY],
          gas: 2100000,
          gasPrice: 8000000000,
          saveDeployments: true,
              },
       },
  etherscan: {
    apiKey: etherscanApiKey
      },
      solidity: {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
};

