


document.getElementById('testContractInteraction').onclick = async function() {

  await hwcToken.methods.owner().call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log("Contract Owner: ", res)
  });

  await hwcToken.methods.balanceOf(senderAddress).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log("The balance is: ", res)
  })
};


var HWC = (async function (wind, doc) {
  // private
  const adminAddress = "0x9c3C6ff39f65689ED820476362615a347bB23b3F";
  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const hwcTokenContract = new web3.eth.Contract(ECR20_HWCABI, HWC_ADDRESS.goerli);

  // Document elements
  let walletBalanceDiv = doc.getElementById('walletBalance');
  let stakedBalanceDiv = doc.getElementById('stakedBalance');

    await hwcTokenContract.methods.balanceOf(adminAddress).call(function (err, res) {
      if (err) {
        console.log("An error occured", err)
        return
      }
      walletBalanceDiv.innerHTML = res;
      console.log("The balance is: ", res)
    })

  // HWC gets set to this!
  return {
    contract : hwcTokenContract,
    provider : web3
  };
}(window, document));
