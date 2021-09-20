var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');

const hwcToken = new web3.eth.Contract(ECR20_HWCABI, HWC_ADDRESS.goerli)


const senderAddress = "0x9c3C6ff39f65689ED820476362615a347bB23b3F"
const receiverAddress = "0x19dE91Af973F404EDF5B4c093983a7c6E3EC8ccE"

document.getElementById('testContractInteraction').onclick = async function() {
  /*
  await hwcToken.methods.initialize().call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log("Contract Owner: ", res)
  });
  */
  await hwcToken.methods.balanceOf(senderAddress).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log("The balance is: ", res)
  })
};
