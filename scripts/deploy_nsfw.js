// Right click on the script name and hit "Run" to execute

// run via:
// npx hardhat run .\scripts\deploy_upgradable.js --network ropsten
const { ethers, upgrades } = require('hardhat');


(async () => {
    try {
        console.log('Running deployWithEthers script for WolverNFT...')

        const contractName = 'Wolvercoin_NFT' // Change this for other contract

        // Args:
        // string Name
        // string Symbol
        // string Password (for minting)
        const constructorArgs = ["Not-So-Fungible-Wolvies", "NSFW", "12345"]

        // Note that the script needs the ABI which is generated from the compilation artifact.
        // Make sure contract is compiled and artifacts are generated
        const artifactsPath = `browser/contracts/examples/artifacts/${contractName}.json` // Change this for different path

        const metadata = JSON.parse(await remix.call('fileManager', 'getFile', artifactsPath))
        // 'web3Provider' is a remix global variable object
        const signer = (new ethers.providers.Web3Provider(web3Provider)).getSigner()

        let factory = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);

        let contract = await factory.deploy(...constructorArgs);

        console.log('NSFW Contract Address: ', contract.address);

        // The contract is NOT deployed yet; we must wait until it is mined
        await contract.deployed()
        console.log('WolverNFT deployment successful!')
    } catch (e) {
        console.log(e.message)
    }
})()
