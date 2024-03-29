# EthereumCoin Installation
git clone git@github.com:andrewtheiss/EthereumCoin.git
cd EthereumCoin



# Development
After you have installed dependencies (Under 'Installation' and 'Contract Upgradability') you can hook your directory directly into remix.ethereum.org via
`remixd -s C:\Users\andre\Documents\WebDev\EthereumCoin --remix-ide https://remix.ethereum.org`
`remixd -s D:\Program Files\Github\EthereumCoin --remix-ide https://remix.ethereum.org`

# Installation
To start, install node version 16 (not 14)
To interface with Remix, we need to install npm and the latest remixd package (which interfaces with remix.ethereum). To do this, follow directions at https://remix-ide.readthedocs.io/en/latest/remixd.html or type
`npm install -g @remix-project/remixd`.  If you're out of date, perhaps try `npm uninstall -g remixd` first.

# Contract Upgradability
To upgrade this contract into a blockchain which is immutable, we need to create this contract via a proxy.  The proxy will hold the implementation, and admin in charge of the contract, and the proxy contract / initializer. Using OpenZeppelin for this as USDC seems to use the same.
Upgradability requires the hardhat package `https://docs.openzeppelin.com/upgrades-plugins/1.x/hardhat-upgrades` via `$ npm install --save-dev @openzeppelin/hardhat-upgrades @nomiclabs/hardhat-ethers ethers`

Note: Upgradable contracts can only add additional variable storage (and cannot remove/modify any existing).
The ProxyAdmin is the single source in charge of deploying contracts.  Can be changed via 'transferOwndership'

Upgradable contracts have to parts: Proxy and implementation
Proxy holds all state information
Implementation ... obviously implements how the code is executed

# Hardhat
Upgradability requires Hardhat to be installed as well into the project root.
`npm install --save-dev hardhat`
`npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers`  // For testing
`npm install --save-dev @nomiclabs/hardhat-web3 web3`
`npm install --save-dev @openzeppelin/contracts-upgradeable`

# Updating node:
Use moralis.io
https://faucets.blockxlabs.com/ for eth
https://faucet.goerli.mudit.blog/

# Deployment
// Deployment of the base contract (only really done once.. all subsequent calls should only deploy the implementation)
`npx hardhat run .\scripts\deploy_upgradable.js --network goerli --show-stack-traces`

`npx hardhat run .\scripts\deploy_upgradable_implementation.js --network goerli --show-stack-traces`

// And obviously similar for Wolver NFT
`npx hardhat run .\scripts\deploy_nsfw.js --network goerli --show-stack-traces`

# Testing
// Testing automatically runs everything inside the 'test' directory and leverages Chai for testing
// https://ethereum-waffle.readthedocs.io/en/latest/matchers.html
`npx hardhat test --show-stack-traces`

# Paying for other people's transactions {https://docs.opengsn.org/javascript-client/tutorial.html#introduction}
`npm install @opengsn/provider --save`


# Plans
After meeting with HW Crypto Club:  The following plans have been created.
- Max Supply of 62 million
- Staking
- Staking with timelock
- Burn NTF Purchases
- Pre Mine 62K
- Start Auction (if admin, start auction for NFT address)
    - Accept only WVC
    - Mint function for admin?
 - Deposit to all class addresses

# Phase 2 plans
- Decentrallized governance
- Delete admin keys
-

# Release plans
- 1 token per class per student?


# App Details
- install firebase in the /app/ directory `npm install firebase`
- install firebase tools `npm install -g firebase-tools`
