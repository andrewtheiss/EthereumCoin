


/**
 *
 *  Check if on polygon network or testnet and
 */
async function checkAndNotifyOfWrongNetwork() {

  const provider = await detectEthereumProvider();
  if (provider) {
    const chainId = await provider.request({
        method: 'eth_chainId'
      })

      // If the current blockchain is not the desired network, show the button to switch
      const containerElement = document.querySelector('#switch-network');
      const buttonElement = document.querySelector('#switch-network-button');
      let env = NETWORK[ENV];            // dev or prod
      let env_name = NETWORK.NAME[env];  // goerli or matic
      if (chainId != NETWORK.CHAIN_ID[NETWORK[ENV]]) {
        if (containerElement.classList.contains("hidden")) {
          containerElement.classList.remove("hidden");
        }
        buttonElement.innerHTML = "Wrong Network!  Click to connect to " + env_name + "";
      } else {
        if (!containerElement.classList.contains("hidden")) {
          containerElement.classList.add("hidden");
        }
      }
  }
}


document.getElementById("switch-network-button").onclick = async function() {
 switchToCorrectNetwork();
};

async function showBalances() {

    if (!Wolvercoin.currentAccount) {
      return;
    }

    var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
    const WolvercoinContract = new web3.eth.Contract(ECR20_WVCABI, WVC_ADDRESS.goerli);

    // Document elements
    let walletBalanceDiv = document.getElementById('walletBalance');
    let stakedBalanceDiv = document.getElementById('stakedBalance');

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
    Wolvercoin.contract = WolvercoinContract;
    Wolvercoin.provider = web3;

}

/**
 * showWalletConnected
 *    will update all UI elements given the connected account
 */
let lookupNFTTimeout = false;
async function showWalletConnected() {
  const el = document.querySelector('#wallet-connected');
  if (el.classList.contains("hidden")) {
    el.classList.remove("hidden");
  }

  const el2 = document.querySelector('#wallet-connect-button');
  if (!el2.classList.contains("hidden")) {
    el2.classList.add("hidden");
  }

  if (Wolvercoin.currentAccount == '0x9c3c6ff39f65689ed820476362615a347bb23b3f') {
      const el = document.querySelector('#isAdminOnly');
      if (el.classList.contains("hidden")) {
        el.classList.remove("hidden");
        $('#prodNft_ID').change(function(event) {
            // Grab and update NFT
          let id = event.target.value;

          if (lookupNFTTimeout != false) {
            clearTimeout(lookupNFTTimeout);
          }
          lookupNFTTimeout = setTimeout(async function(){
            var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
            if (!Wolvercoin.contracts.wolvercoinNFT.ABI) {
              console.log("NO WOLVERCOIN NFT ABI");
              return;
            }
            const NSFWContract = new web3.eth.Contract(Wolvercoin.devContracts.wolvercoinNFT.ABI, Wolvercoin.devContracts.wolvercoinNFT.address);
            await NSFWContract.methods.tokenURI($('#prodNft_ID').val()).call(function (err, res) {
              if (err) {
                console.log("An error occured", err);
                return
              } else {
                $('#prodNft_ID_nftTokenMetadata').val(res);
                $.ajax({
                  url: res,
                  dataType: 'json',
                  complete : function(res){
                      //alert(this.url)
                  },
                  success: function(json){
                    $('#prodNft_ID_nftTokenMetadata').val(JSON.stringify(json));
                  }
              });
              }
            });
          }, 2000);

        });
        $('#prodNft_createAuctionButton').click(async function() {
          let nftId = $('#prodNft_ID').val();
          let startTimeHoursFromNow = $('#prodNft_startTimeHoursFromNow').val();
          let durationHours = $('#prodNft_durationHours').val();
          let startingPrice = Number($('#prodNft_startingPrice').val())  * Math.pow(10,18);
          let tokenURI = $('#prodNft_ID_nftTokenMetadata').val();
          var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546');
          const NSFWContract = new web3.eth.Contract(Wolvercoin.contracts.wolvercoinAuction.ABI, Wolvercoin.contracts.wolvercoinAuction.address);
          await NSFWContract.methods.addAuctionRelativeTimes(
            nftId,
            startTimeHoursFromNow,
            durationHours,
            startingPrice + '',
            tokenURI
          ).send({
            from: Wolvercoin.currentAccount
          })
          .then(function(result) {
            console.log(result);
          });
        })
      }
  }

  // Check and notify of wrong network
  checkAndNotifyOfWrongNetwork();

// Wolvercoin.currentAccount
  const link = document.getElementById('link-to-etherscan');
  let account = Wolvercoin.currentAccount.substring(0,5) + "..." +  Wolvercoin.currentAccount.substring(Wolvercoin.currentAccount.length-4, Wolvercoin.currentAccount.length);
  let chainSearch = "etherscan.io";
  switch (ethereum.chainId) {
    case "0x1" :
      chainSearch = "etherscan.io";
      break;
    case "0x3" :
      chainSearch = "ropsten." + chainSearch;
      break;
    case "0x4" :
      chainSearch = "rinkeby." + chainSearch;
      break;
    case "0x5" :
      chainSearch = "goerli." + chainSearch;
      break;
    case "0x2a" :
      chainSearch = "kovan." + chainSearch;
      break;
    case "0x89" :
      chainSearch = "polygonscan.com";
      break;
    case "0x13881" :
      chainSearch = "mumbai.polygonscan.com";
      break;
    default:
      break;
  }
  let scanLink = "https://" + chainSearch + "/address/" + Wolvercoin.currentAccount;
  link.href = scanLink;
  link.innerHTML = account;
}

/**
 *  Create button event to connect MetaMask account
 */
document.getElementById("wallet-connect-button").onclick = async function() {
  switchToCorrectNetwork();
  try {

    // Step 1 is giving metamask permission to access the website
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    Wolvercoin.currentAccount = accounts[0];
    showWalletConnected();
    showBalances();

    // Grab provider details
    const provider = await detectEthereumProvider()// Request account access if needed
    console.log(provider);

    if (provider) {
      const chainId = await provider.request({
          method: 'eth_chainId'
        })
        console.log(chainId);
    } else {

    }

  } catch (error) {
      // User denied account access
  }
}


function handleChainChanged(_chainId) {
  // We recommend reloading the page, unless you must do otherwise
  window.location.reload();
}


// For now, 'eth_accounts' will continue to always return an array
function handleAccountsChanged(accounts) {
  if (accounts.length === 0) {
    // MetaMask is locked or the user has not connected any accounts
    console.log('Please connect to MetaMask.');
  } else if (accounts[0] !== Wolvercoin.currentAccount) {
    Wolvercoin.currentAccount = accounts[0];
    showWalletConnected();
  }
}
document.addEventListener('DOMContentLoaded', async function() {


  let currentAccount = null;
  ethereum
    .request({ method: 'eth_accounts' })
    .then(handleAccountsChanged)
    .catch((err) => {
      // Some unexpected error.
      // For backwards compatibility reasons, if no accounts are available,
      // eth_accounts will return an empty array.
      console.error(err);
    });
});

ethereum.on('disconnect', (accounts) => {
  window.location.reload();
});

ethereum.on('accountsChanged', (accounts) => {
  // Handle the new accounts, or lack thereof.
  // "accounts" will always be an array, but it can be empty.
});

ethereum.on('chainChanged', (chainId) => {
  // Handle the new chain.
  // Correctly handling chain changes can be complicated.
  // We recommend reloading the page unless you have good reason not to.
  window.location.reload();
});



async function switchToCorrectNetwork() {
  let env = NETWORK[ENV];            // dev or prod
  let env_name = NETWORK.NAME[env];  // goerli or matic
  let chainParams = NETWORK.PARAMS[env_name]  // Object of all params, ID, jsonrpc.. etc

  try {
    await ethereum.request({
      method: 'wallet_switchEthereumChain',
      params: [{ chainId: chainParams.params[0].chainId }],
    });
  } catch (switchError) {
    // This error code indicates that the chain has not been added to MetaMask.
    if (switchError.code === 4902) {
      try {
        await ethereum.request(chainParams);
      } catch (addError) {
        // handle "add" error
      }
    }
    // handle other "switch" errors
  }

}

// Counter to continue checking for network
(async function (wind, doc) {

    wind.checkChain = setInterval(function() {
        checkAndNotifyOfWrongNetwork();
    }, 3000);
})(window, document);
