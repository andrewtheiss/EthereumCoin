document.getElementById('checkBalanceForWallet').onclick = async function() {

  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

  let walletId = document.getElementById('checkBalanceForWallet_WalletId').value;

  if (walletId.length < 10) {
    return;
  }
  await WolvercoinContract.methods.balanceOf(walletId).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    let balance = Number(res) / Math.pow(10,18);
    if (balance < 0.0001) {
      if (balance == 0) {
        balance = '0';
      } else {
        balance = "< 0.0001";
      }
    }
    console.log("The wallet balance is " + balance);
  });
};


$('#removeAuctionByNFTId').click(async function() {
  let nftId = $('#removeAuctionByNFTId_nftId').val();
  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinAuctionContract = new web3.eth.Contract(Wolvercoin.contracts.wolvercoinAuction.ABI, Wolvercoin.contracts.wolvercoinAuction.address);
  await WolvercoinAuctionContract.methods._removeAuction(nftId).send({
    from: Wolvercoin.currentAccount
  })
  .then(function(result) {
    console.log(result);
  });
});



document.getElementById('getWalletsForClass').onclick = async function() {
  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

  let classPeriod = document.getElementById('getWalletsForClass_ClassPeriod').value;
  if (isNaN(classPeriod)) {
    classPeriod = 0;
  }
  await WolvercoinContract.methods.getAllAddressesForClassPeriod(classPeriod).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    let walletsForPeriod = document.getElementById('walletsForPeriod');
    walletsForPeriod.innerHTML = "The wallets for period " + classPeriod + " are: " + JSON.stringify(res);
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
    .send({from : Wolvercoin.currentAccount})
    .then(function(result, v1, v2) {
      console.log(result);
    });
  };
};

document.getElementById('removeWalletFromClass').onclick = async function() {

  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

  // Document elements
  let classPeriod = document.getElementById('removeWalletFromClass_ClassPeriod');
  let walletId = document.getElementById('removeWalletFromClass_WalletId');
  if (classPeriod.value.length > 0 && walletId.value.length > 0) {
    // https://web3js.readthedocs.io/en/v1.2.11/web3-eth-contract.html#methods-mymethod-send
    await WolvercoinContract.methods.removeAddressFromClassPeriod(classPeriod.value, walletId.value)
    .send({from : Wolvercoin.currentAccount})
    .then(function(result) {
      console.log(result);
    });
  };
};

document.getElementById('sendCoinToClassPeriod').onclick = async function() {
  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

  let classPeriod = document.getElementById('sendCoinToClassPeriod_ClassPeriod');
  let amount = document.getElementById('sendCoinToClassPeriod_amount');
  if (amount.value <= 0) {
    return;
  }

  let amountToSend = amount.value * Math.pow(10,18);
  amountToSend = amountToSend + '';
  amount.value = "";
  await WolvercoinContract.methods.sendCoinToClassPeriod(classPeriod.value, amountToSend)
    .send({from : Wolvercoin.currentAccount})
    .then(function(result) {
      console.log(result);
    });
};



document.getElementById('addCoinToMetamask').onclick = async function() {
  //alert("Contract Address: " + WVC_ADDRESS.goerli);
  const tokenAddress = WVC_ADDRESS.goerli;
  const tokenSymbol = 'WVC';
  const tokenDecimals = 18;
  const tokenImage = 'http://wolvercoin.com/wvc.png';

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

  var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
  const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);
  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  Wolvercoin.currentAccount = accounts[0];
  wind.showWalletConnected();

  if (!Wolvercoin.currentAccount) {
    return;
  }

  // Document elements
  let walletBalanceDiv = doc.getElementById('walletBalance');
  let stakedBalanceDiv = doc.getElementById('stakedBalance');

  await WolvercoinContract.methods.balanceOf(Wolvercoin.currentAccount).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    let balance = Number(res) / Math.pow(10,18);
    if (balance < 0.0001) {
      if (balance == 0) {
        balance = '0';
      } else {
        balance = "< 0.0001";
      }
    }
    walletBalanceDiv.innerHTML = balance;
    console.log("The balance is: ", res)
  });

  await WolvercoinContract.methods.stakedBalanceOf(Wolvercoin.currentAccount).call(function (err, res) {
    if (err) {
      console.log("An error occured", err)
      return
    }
    let balance = Number(res) / Math.pow(10,18);
    if (balance < 0.0001) {
      if (balance == 0) {
        balance = '0';
      } else {
        balance = "< 0.0001";
      }
    }
    stakedBalanceDiv.innerHTML = balance;
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
