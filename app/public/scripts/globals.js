// Environment and Netowork go hand in hand
let ENV = 'DEV';
let Wolvercoin = {
  currentAccount : ""
};



/*
  Below are the network details for any of the possbile networks

  // Usage:
  // TODO - Make functions which return this cause it's confusing AF
  let env = NETWORK[ENV];            // dev or prod
  let env_name = NETWORK.NAME[env];  // goerli or matic
  let env_params = NETWORK.PARAMS[env_name]  // Object of all params, ID, jsonrpc.. etc
 */
let NETWORK = {
  DEV : 'dev',
  PROD : 'prod',
  CHAIN_ID : {
    dev : "0x5", // Goerli
    prod : "0x89"
  },
  NAME : {
    dev : "Goerli",
    prod : "Matic"
  },
  PARAMS : {
    Goerli : {
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
      },
      Matic : {
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
          chainName : 'Matic'
         }]
      }

  }
};
