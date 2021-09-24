// We need to deploy the Proxy before deploying the rest of the contract.  
// This is the first step in an upgradable proxy

// run via:
// npx hardhat run .\scripts\deploy_upgradable.js --network ropsten
const { ethers, upgrades } = require('hardhat');

async function main () {
  const WVCProxyAddress = "0x79A5511Ba5A6fEAcb4110e7074ED25b832479487";
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
