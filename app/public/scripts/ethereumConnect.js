let NETWORK_ENV = 'DEV'; // 'PROD' is

/**
 *
 *  Check if on polygon network or testnet and
 */
function checkAndNotifyOfWrongNetwork() {
  // Check network ID's : Move this to a config file

}

/**
 * showWalletConnected
 *    will update all UI elements given the connected account
 */
function showWalletConnected() {
  const el = document.querySelector('#wallet-connected');
  if (el.classList.contains("hidden")) {
    el.classList.remove("hidden");

  }
  const el2 = document.querySelector('#wallet-connect-button');
  if (!el2.classList.contains("hidden")) {
    el2.classList.add("hidden");
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
  swtichToPolygonNetwork();
  try {

    // Step 1 is giving metamask permission to access the website
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    Wolvercoin.currentAccount = accounts[0];
    showWalletConnected();

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



async function swtichToPolygonNetwork() {
  // Swtich Eth chain to desired mainnet
  try {
    await ethereum.request({
      method: 'wallet_switchEthereumChain',
      params: [{ chainId: '0x89' }],
    });
  } catch (switchError) {
    // This error code indicates that the chain has not been added to MetaMask.
    if (switchError.code === 4902) {

      //
    let goerli = {
        "id": 1,
        "jsonrpc": "2.0",
        "method": "wallet_addEthereumChain",
        "params": [
          {
            "chainId": "0x5",
            "chainName": "Goerli",
            "rpcUrls": ["https://goerli.infura.io/v3/INSERT_API_KEY_HERE"],
            "nativeCurrency": {
              "name": "Goerli ETH",
              "symbol": "gorETH",
              "decimals": 18
            },
            "blockExplorerUrls": ["https://goerli.etherscan.io"]
          }
        ]
      };

      let matic = {
        method: 'wallet_addEthereumChain',
        params: [{
          // MUST specify the integer ID of the chain as a hexadecimal string, per the eth_chainId Ethereum RPC method.
          // The wallet SHOULD compare the specified chainId value with the eth_chainId return value from the endpoint.
          // If these values are not identical, the wallet MUST reject the request.
          chainId: '0x89',

          // If provided, MUST specify one or more URLs pointing to RPC endpoints that can be used to communicate with the chain.
          rpcUrls: ['https://rpc-mainnet.matic.network'],

          // Seriously you need a comment for this?
          symbol: 'MATIC',

          // If provided, MUST specify one or more URLs pointing to block explorer web sites for the chain.
          blockExplorerUrls : ['https://polygonscan.com/'],

          nativeCurrency: {
            name: "MATIC",
            symbol: "MATIC",
            decimals: 18
          },

          // If provided, MUST specify a human-readable name for the chain.
          chainName : 'Polygon'
         }]
      };
      try {
        await ethereum.request(matic);
      } catch (addError) {
        // handle "add" error
      }
    }
    // handle other "switch" errors
  }

}
