


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
  });

  const adminAddress = "0x9c3C6ff39f65689ED820476362615a347bB23b3F";
  const tokenSymbol = 'WVC';
  const tokenDecimals = 18;
  const tokenImage = 'http://placekitten.com/200/300';

  try {
    // wasAdded is a boolean. Like any RPC method, an error may be thrown.
    const wasAdded = await ethereum.request({
      method: 'wallet_watchAsset',
      params: {
        type: 'ERC20', // Initially only supports ERC20, but eventually more!
        options: {
          address: tokenAddress, // The address that the token is at.
          symbol: tokenSymbol, // A ticker symbol or shorthand, up to 5 chars.
          decimals: tokenDecimals, // The number of decimals in the token
          image: tokenImage, // A string url of the token logo
        },
      },
    });

    if (wasAdded) {
      console.log('Thanks for your interest!');
    } else {
      console.log('Your loss!');
    }
  } catch (error) {
    console.log(error);
  }
};


var WVC = (async function (wind, doc) {
  // private
  const adminAddress = "0x9c3C6ff39f65689ED820476362615a347bB23b3F";
  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const hwcTokenContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

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

  // WVC gets set to this!
  return {
    contract : hwcTokenContract,
    provider : web3
  };
}(window, document));
