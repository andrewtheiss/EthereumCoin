// We need to deploy the Proxy before deploying the rest of the contract.  
// This is the first step in an upgradable proxy

// run via:
// npx hardhat run .\scripts\deploy_upgradable.js --network ropsten
const { ethers, upgrades } = require('hardhat');

async function main () {
  const HWC = await ethers.getContractFactory('HWC');
  console.log('Deploying HWC...');
  const hwc = await upgrades.deployProxy(HWC, [], { initializer: 'initialize' });
  await hwc.deployed();
  console.log('HWC deployed to:', hwc.address);
}

main();
