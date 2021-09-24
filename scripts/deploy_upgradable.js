// We need to deploy the Proxy before deploying the rest of the contract.  
// This is the first step in an upgradable proxy

// run via:
// npx hardhat run .\scripts\deploy_upgradable.js --network ropsten
const { ethers, upgrades } = require('hardhat');

async function main () {
  const WVC = await ethers.getContractFactory('Wolvercoin');
  
  // Parameters for how to deploy are https://docs.openzeppelin.com/upgrades-plugins/1.x/api-truffle-upgrades
  const wolvercoin = await upgrades.deployProxy(
      WVC, 
      [], // args for initialize
      { 
          initializer: 'initialize', 
          kind: 'uups' 
      }
   );
  
  console.log('Deploying WVC...');
  await wolvercoin.deployed();
  console.log('Wolvercoin deployed to:', wolvercoin.address);
}

main();
