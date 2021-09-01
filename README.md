# EthereumCoin

# Development
After you have installed dependencies (Under 'Installation' and 'Contract Upgradability') you can hook your directory directly into remix.ethereum.org via
`remixd -s C:\Users\andre\Documents\WebDev\EthereumCoin --remix-ide https://remix.ethereum.org`

# Installation
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
`npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers`
`npm install --save-dev @nomiclabs/hardhat-web3 web3`
`npm install --save-dev @openzeppelin/contracts-upgradeable`