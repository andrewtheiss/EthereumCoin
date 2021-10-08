// We need to deploy the Proxy before deploying the rest of the contract.  
// This is the first step in an upgradable proxy

// run via:
// npx hardhat run .\scripts\deploy_upgradable.js --network ropsten
const { ethers, upgrades } = require('hardhat');

async function main () {
  const WVCProxyAddress = "0x9615f92DC41613cD06497330B4e2a8FE570ABb24";
  const WVCUpgrade = await ethers.getContractFactory('Wolvercoin');
  console.log('Deploying WVC Upgrade...');
  const wvc = await upgrades.upgradeProxy(
      WVCProxyAddress, 
      WVCUpgrade, 
      {}
    );
  await wvc.deployed();
  console.log('WVC upgraded to:', wvc.address);
}

main();
