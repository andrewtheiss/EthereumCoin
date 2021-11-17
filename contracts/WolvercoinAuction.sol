// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

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
    
    // All auctions
   ClassicAuction[] public _allAuctions;
   ClassicAuction[] public _activeAuctions;
    
    
    uint256 private _totalAuctionCount;
    struct ClassicAuction {
        uint nftId;
        uint256 startTime;
        uint256 endTime;
        bool auctionEnded;
        address highestBidder;
        uint256 highestBid;
    }
    
    
    constructor() public {
        _totalAuctionCount = 0;
        
        // Set amount of wovercoin to 
        _wolvercoin = IERC20(address(0xA7FF8d87F8692FDbe42689d84EA03881cFAdca08));
        _wolvercoinNFTs = IERC721(address(0x13066EE900a8C4e2C9cD7cE0096ADF9B907D0CfF));
        
    }

    
    /*  
     *  // _allAuctions array + access
     *  1 Create array of 'AllAuctions' (_allAuctions) with either index or mapping
     *      a. Create a getter to grab an auction by index
     */
    function findAuctionIndexByNftId(uint nftId) public view returns (uint256 auctionIndex) {
        for (uint i = 0; i < _allAuctions.length; i++) {
            if (_allAuctions[i].nftId == nftId) {
                auctionIndex = i;
                i = _allAuctions.length;
            }
        }
    }
    
    // Deleting an element creates a gap in the array.
    // One trick to keep the array compact is to
    // move the last element into the place to delete.
    function removeAuctionByIndex(uint index) public {
        require(index < _activeAuctions.length, "index out of bound");
        
        // Move the last element into the place to delete
        _allAuctions[index] = _allAuctions[_allAuctions.length - 1];
        
        // Remove the last element
        _allAuctions.pop();
    }
    
    function addAuction(uint _nftId, uint256 _startTime, uint256 _endTime, uint256 _startingBid) public {
        ClassicAuction memory newAuction = ClassicAuction({
            nftId : _nftId,
            startTime : _startTime,
            endTime : _endTime,
            auctionEnded : false,
            highestBidder : address(0),
            highestBid : _startingBid
        });
        _allAuctions.push(newAuction);
    }
    
    function getAllAuctions() public view returns (ClassicAuction[] memory) {
        return _allAuctions;
    }
     
     /*  // _activeAuctions array + access
     *  2 Create array of 'ActiveAuctions' (_activeAuctions)
     *      a. Create method to Add an 'Auction' struct to ActiveAuctions array
     *      b. Create method to Remove an 'Auction' struct to ActiveAuctions array
     */
     /*
     *      c. Copy and paste behavior for 'FinishedAuctions'
     *
     *  // Check Expired
     *  3 Create method which checks if an auction is expired, returns a bool
     *      a. Create a method which is a modifier of similar behavior (we need both types)
     */
     modifier isAuctionExpired(ClassicAuction memory auction) {
         bool ended = auction.auctionEnded;
         bool outOfTimeFrame = (auction.endTime < block.timestamp) && (auction.startTime > block.timestamp);
         require(ended || outOfTimeFrame, "Auction has expired");
         _;
     }
     
     modifier auctionStarted(ClassicAuction memory auction) {
         require(block.timestamp > auction.startTime && block.timestamp < auction.endTime && !auction.auctionEnded, "Auction not running");
         _;
     }
     
     /*  // Get auction
     *  4 Create a method which grabs an acution by nftId or activeAuctionId
     *    a. activeAuctionId will be the id used to access the _activeAuctions
     */
     function getAuctionByNftId(uint256 _nftId) public view returns (ClassicAuction memory auctionToReturn) {
         for (uint i = 0; i < _allAuctions.length; i++) {
             if (_allAuctions[i].nftId == _nftId) {
                 auctionToReturn = _allAuctions[i]; 
             }
         }
     }
     
     /*
     *  // Approval
     *  5 Create a method to check if the msg.sender is approved for given amount of wolvercoin spending
     *      a. should return a bool
     */
     modifier isApprovedForWolvercoin(uint amount) {
         uint256 howMuchWolvercoinCanThisContractSpend = _wolvercoin.allowance(msg.sender, address(this));
         require(howMuchWolvercoinCanThisContractSpend > amount, "Please approve more wolvercoin spending");
         _;
     }
     
     /*  // Pay wolvercoin to contract (transferFrom)
     *  6 Create a method to transfer a certain uint256 value of wolvercoin to this contract 
     *      a. Should transfer wolvercoin from their address
     *      b. This address is address(this)
     *      c. Either fails or returns false, up to you.  B smart
     
     /*  // Pay wolvercoin to highest bidder
     *  6.1 Create a method to pay an Auction's highestBidder from this contract (transfer)
     *
     *  // Bid
     *  7 Create method to bid on a Auction given an nftId and amount
     *
     *  // Transfer nft
     *  8 Transfer NFT to address of Auction highestBidder
     *      a. Requires a modifier requiring auction to be ended
     */
    
    function transferNFT(ClassicAuction memory auction) public pure {
        require(auction.auctionEnded, "Auction has not ended");
    //   _wolvercoinNFTs.safeTransferFrom(address(this), auction.highestBidder, auction.nftId);
    }
    
     /*
     *
     *  // Extend auction  
     *  9 Extends an auction given amount of time
     *      a. Takes an auction and extends its end time
     *
     *  
     *
     */
    
    function setNFT(address _nft) public onlyOwner {
        _wolvercoinNFTs = IERC721(_nft);
    }
    
    function testPayAuction(uint256 amount) public {
        // sender, recipient, amount
        _wolvercoin.transferFrom(msg.sender, address(this), amount);
    }

    function extendAuction(ClassicAuction memory auction, uint256 extension) public pure{
        auction.endTime += extension;
     }

}