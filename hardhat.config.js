require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-web3");
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');

let secret = require("./scripts/hardhat/secret.json")

task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async (taskArgs) => {

    const account = web3.utils.toChecksumAddress(taskArgs.account);
    const balance = await web3.eth.getBalance(account);

    console.log(web3.utils.fromWei(balance, "ether"), "ETH");
});

task("delayed-hello", "Prints 'Hello, World!' after a second", async () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("Hello, World!");
      resolve();
    }, 1000);
  });
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.7",
  networks: {
      ropsten: {
          url : secret.url,
          accounts : [secret.key]
      },
      kovan: {
          url : secret.kovanUrl,
          accounts : [secret.key]
      },
      rinkeby: {
          url : "https://speedy-nodes-nyc.moralis.io/152b90f24e6ee9dbba3494ba/eth/rinkeby",
          accounts : ["4921cd08d350c54abcbd1f8843e921643046036f9251d4fa4199ae36d4bb2dcb"]
      },
      goerli: {
          url : "https://speedy-nodes-nyc.moralis.io/97baba290fa95486247731ca/eth/goerli",
          accounts : ["4921cd08d350c54abcbd1f8843e921643046036f9251d4fa4199ae36d4bb2dcb"]
      }
  }
};
