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

// HWCoin.currentAccount
  const link = document.getElementById('link-to-etherscan');
  let account = HWCoin.currentAccount.substring(0,5) + "..." +  HWCoin.currentAccount.substring(HWCoin.currentAccount.length-4, HWCoin.currentAccount.length);
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
    default:
      break;
  }
  let scanLink = "https://" + chainSearch + "/address/" + HWCoin.currentAccount;
  link.href = scanLink;
  link.innerHTML = account;
}

/**
 *  Create button event to connect MetaMask account
 */
document.getElementById("wallet-connect-button").onclick = async function() {
  try {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    HWCoin.currentAccount = accounts[0];

    // Update UI to show account
    console.log(account);
    showWalletConnected(account);

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
  } else if (accounts[0] !== HWCoin.currentAccount) {
    HWCoin.currentAccount = accounts[0];
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
