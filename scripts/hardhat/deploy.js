// run via:
// npx hardhat run .\scripts\hardhat\deploy.js --network ropsten
const hre = require("hardhat")

async function main() {
    const HWC = await hre.ethers.getContractFactory("HWC");
    const hwc = await HWC.deploy();
    
    await hwc.deployed();
    console.log("Deployed HWC to",storage.address);
    
    main().then( () => process.exit(0)).catch(error=>{
        console.error(error);
        process.exit(1);
    })
}
