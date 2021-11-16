// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
// Allows for onlyOwner modifier
// auto-sets variable address '_owner' as owner
import "@openzeppelin/contracts/access/Ownable.sol"; 

contract WolvercoinAuction is Ownable {
    
    event Win(address winner, uint256 amount);

    IERC721 private _wolvercoinNFTs;
    IERC20 immutable private _wolvercoin;
    
    
    uint256 private _totalAuctionCount;
    struct ClassicAuction {
        uint nftId;
        uint256 startTime;
        uint256 endTime;
        bool auctionEnded;
        address highestBidder;
        uint256 highestBid;
    }
    
    // Todo:
    
    /*  
     *  // _allAuctions array + access
     *  1 Create array of 'AllAuctions' (_allAuctions) with either index or mapping
     *      a. Create a getter to grab an auction by index
     *
     *  // _activeAuctions array + access
     *  2 Create array of 'ActiveAuctions' (_activeAuctions)
     *      a. Create method to Add an 'Auction' struct to ActiveAuctions array
     *      b. Create method to Remove an 'Auction' struct to ActiveAuctions array
     *      c. Copy and paste behavior for 'FinishedAuctions'
     *
     *  // Check Expired
     *  3 Create method which checks if an auction is expired, returns a bool
     *      a. Create a method which is a modifier of similar behavior (we need both types)
     *
     *  // Get auction
     *  4 Create a method which grabs an acution by nftId or activeAuctionId
     *    a. activeAuctionId will be the id used to access the _activeAuctions
     *
     *  // Approval
     *  5 Create a method to check if the msg.sender is approved for given amount of wolvercoin spending
     *      a. should return a bool
     *  
     *  // Pay wolvercoin to contract (transferFrom)
     *  6 Create a method to transfer a certain uint256 value of wolvercoin to this contract 
     *      a. Should transfer wolvercoin from their address
     *      b. This address is address(this)
     *      c. Either fails or returns false, up to you.  B smart
     *
     *  // Pay wolvercoin to highest bidder
     *  6.1 Create a method to pay an Auction's highestBidder from this contract (transfer)
     *
     *  // Bid
     *  7 Create method to bid on a Auction given an nftId and amount
     *
     *  // Transfer nft
     *  8 Transfer NFT to address of Auction highestBidder
     *      a. Requires a modifier requiring auction to be ended
     *
     *  // Extend auction  
     *  9 Extends an auction given amount of time
     *      a. Takes an auction and extends its end time
     *
     *  
     *
     */
    
    
    IERC721 public nft;
    uint public nftId;

    address payable public seller;

    constructor() {
        _totalAuctionCount = 0;
        
        // Set amount of wovercoin to 
        _wolvercoin = IERC20(address(0xA7FF8d87F8692FDbe42689d84EA03881cFAdca08));
        _wolvercoinNFTs = IERC721(address(0x13066EE900a8C4e2C9cD7cE0096ADF9B907D0CfF));
        
    }
    
    function setNFT(address _nft) public onlyOwner {
        _wolvercoinNFTs = IERC721(_nft);
    }
    
    function testPayAuction(uint256 amount) public {
        // sender, recipient, amount
        _wolvercoin.transferFrom(msg.sender, address(this), amount);
    }
    
    // Can call approve to pay WVC to any contract via http://wolvercoin.com/#nfts#0x9b37E894FB19050A9679AE8a964684B5aa0a29f8
    // where '0x9b37E894FB19050A9679AE8a964684B5aa0a29f8' is your deployed test WovercoinAuction contract
    function _TEST_approveWolvercoinSpend() public {
        uint256 approvalAmount = 115792089237316195423570985008687907853269984665640564039457584007913129639935; //(2^256 - 1 )
        nft.approve(address(this), approvalAmount);
    }

    // Wins the auction for the specified amount
    function win() external payable {
        nft.safeTransferFrom(address(this), msg.sender, nftId);
        
        // Check approval first
        _wolvercoin.transfer(msg.sender, 10);
    }
    
    function startItemAuction(
        uint _nftId, 
        uint256 _startTime,
        uint256 _endTime) public onlyOwner {
            
        }
}