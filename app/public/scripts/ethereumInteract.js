


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


document.getElementById('getWalletsForClass').onclick = async function() {

  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

  await WolvercoinContract.methods.getAllAddressesForClassPeriod(1).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log("The balance is: ", res)
  });

};


document.getElementById('addWalletToClass').onclick = async function() {

  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

  // Document elements
  let classPeriod = document.getElementById('addWalletToClass_ClassPeriod');
  let walletId = document.getElementById('addWalletToClass_WalletId');
  if (classPeriod.value.length > 0 && walletId.value.length > 0) {
    // https://web3js.readthedocs.io/en/v1.2.11/web3-eth-contract.html#methods-mymethod-send
    await WolvercoinContract.methods.addAddressForClassPeriod(classPeriod.value, walletId.value)
    .send({from : '0x9c3C6ff39f65689ED820476362615a347bB23b3F'})
    .then(function(result) {
      console.log(result);
    });
  };
};

document.getElementById('addCoinToMetamask').onclick = async function() {
  alert("Contract Address: " + WVC_ADDRESS.goerli);
  const tokenAddress = WVC_ADDRESS.goerli;
  const tokenSymbol = 'WVC';
  const tokenDecimals = 18;
  const tokenImage = 'http://wolvercoin.com/wcoin.png';

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
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

  // Document elements
  let walletBalanceDiv = doc.getElementById('walletBalance');
  let stakedBalanceDiv = doc.getElementById('stakedBalance');

  await WolvercoinContract.methods.balanceOf(adminAddress).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    walletBalanceDiv.innerHTML = res;
    console.log("The balance is: ", res)
  });
  await WolvercoinContract.methods.owner().call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log("The admin is: ", res)
  });

  // WVC gets set to this!
  return {
    contract : WolvercoinContract,
    provider : web3
  };
}(window, document));
