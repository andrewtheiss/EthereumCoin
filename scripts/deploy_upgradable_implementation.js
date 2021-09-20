// We need to deploy the Proxy before deploying the rest of the contract.  
// This is the first step in an upgradable proxy

// run via:
// npx hardhat run .\scripts\deploy_upgradable.js --network ropsten
const { ethers, upgrades } = require('hardhat');

async function main () {
  const HWCProxyAddress = "0x701259d84b7e04828437AAf568c8Dc0D98e37141";
  const HWCUpgrade = await ethers.getContractFactory('HWC');
  console.log('Deploying HWC Upgrade...');
  const hwc = await upgrades.upgradeProxy(
      HWCProxyAddress, 
      HWCUpgrade, 
      {}
    );
  await hwc.deployed();
  console.log('HWC upgraded to:', hwc.address);
}

main();
