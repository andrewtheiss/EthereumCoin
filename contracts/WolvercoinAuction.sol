// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./includes/IERC721.sol";
import "./includes/IERC20.sol";

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
// Allows for onlyOwner modifier
// auto-sets variable address '_owner' as owner
// import "@openzeppelin/contracts/access/Ownable.sol"; 
import "./includes/Ownable.sol";

// Behavior 
// AddAuction
// Bid
// TransferCompletedAuctionByNftId after auction
contract WolvercoinAuction is Ownable {
    
    event Win(address winner, uint256 amount);

    IERC721 private _wolvercoinNFTs;
    IERC20 private _wolvercoin;
    
    // All auctions
   ClassicAuction[] public _allAuctions;
   ClassicAuction[] public _finishedAuctions;
    
    
    uint256 private _totalAuctionCount;
    struct ClassicAuction {
        uint nftId;
        uint256 startTime;
        uint256 endTime;
        address seller;
        address highestBidder;
        uint256 highestBid;
    }
    
    
    constructor() {
        _totalAuctionCount = 0;
        
        // Set amount of wovercoin to 
        _wolvercoin = IERC20(address(0xA7FF8d87F8692FDbe42689d84EA03881cFAdca08));
        _wolvercoinNFTs = IERC721(address(0x13066EE900a8C4e2C9cD7cE0096ADF9B907D0CfF));
        _wolvercoin.approve(address(this), 115792089237316195423570985008687907853269984665640564039457584007913129639935);
    }

    // 1 Add Auctions
    function addAuction(uint _nftId, uint256 _startTime, uint256 _endTime, uint256 _startingBid) public onlyOwner auctionDoesntExistsForNFTId(_nftId) {
        ClassicAuction memory newAuction = ClassicAuction({
            nftId : _nftId,
            startTime : _startTime,
            endTime : _endTime,
            seller : address(this),
            highestBidder : address(this),
            highestBid : _startingBid
        });
        _allAuctions.push(newAuction);
    }
    
    function addAuctionRelativeTimes(uint _nftId, uint256 _hoursFromNow, uint256 _hoursAfterStart, uint256 _startingBid) public onlyOwner auctionDoesntExistsForNFTId(_nftId) { 
        ClassicAuction memory newAuction = ClassicAuction({
            nftId : _nftId,
            startTime : block.timestamp + (_hoursFromNow * 3600),
            endTime : block.timestamp + (_hoursFromNow * 3600) + (_hoursAfterStart * 3600),
            seller : address(this),
            highestBidder : address(this),
            highestBid : _startingBid
        });
        _allAuctions.push(newAuction);
    }
    
     /*
     *  2 Bid on auction by nft ID
     */
     function bid(uint256 nftId, uint256 amount) public  {
         // Refund the previous bid
         uint256 auctionIndex = getAuctionIndexByNftId(nftId);
         require(_allAuctions[auctionIndex].highestBid < amount, "There is already a higher bid!");
         
         // Transfer the new higher bid
         transferWovercoinToContract(amount);
         
         // Refund previous bidder only if the auction hasn't started
         if (_allAuctions[auctionIndex].highestBidder != address(this)) {
            refundWovercoinToPreviousBidder(_allAuctions[auctionIndex].highestBid, _allAuctions[auctionIndex].highestBidder);
         }
         
         // Set the new auction details
         _allAuctions[auctionIndex].highestBid = amount;
         _allAuctions[auctionIndex].highestBidder = msg.sender;
         _allAuctions[auctionIndex].endTime = 5 minutes;
     }
     
    
    // 3: Complete auction
    function payAndTransferCompletedAuctionForNftId(uint256 nftId) public {
         ClassicAuction memory auction = getAuctionByNftId(nftId);
         require(block.timestamp > auction.endTime, "Auction needs to end before pay and transfer can occur");
         transferNftAndPayAuctionHighestBidderAndRemoveAuction(auction);
    }

    /*  
     *  4 Getters for Auciton, Auction by NFT ID, etc...
     */
    function getAuctionIndexByNftId(uint nftId) public view returns (uint256 auctionIndex) {
        bool auctionIndexFound = false;
        for (uint i = 0; i < _allAuctions.length; i++) {
            if (_allAuctions[i].nftId == nftId) {
                auctionIndex = i;
                i = _allAuctions.length;
                auctionIndexFound = true;
            }
        }
        require(auctionIndexFound, "No auction exists for given NFT ID");
    }
    
    function getAllAuctions() public view returns (ClassicAuction[] memory) {
        return _allAuctions;
    }
    
     function getAuctionByNftId(uint256 _nftId) public view returns (ClassicAuction memory auctionToReturn) {
         for (uint i = 0; i < _allAuctions.length; i++) {
             if (_allAuctions[i].nftId == _nftId) {
                 auctionToReturn = _allAuctions[i]; 
             }
         }
     }
     
     // Get all finished auctions
    function getAllFinishedAuctions() public view returns (ClassicAuction[] memory) {
        return _finishedAuctions;
    }
     
    
    // Deleting an element creates a gap in the array.
    // One trick to keep the array compact is to
    // move the last element into the place to delete.
    function removeAuctionByIndex(uint index) public {
        require(index < _allAuctions.length, "index out of bound");
        
        // Move the last element into the place to delete
        _allAuctions[index] = _allAuctions[_allAuctions.length - 1];
        
        // Remove the last element
        _allAuctions.pop();
    }

     /*
     *  // Check Expired
     *  3 Create method which checks if an auction is expired, returns a bool
     *      a. Create a method which is a modifier of similar behavior (we need both types)
     */
     modifier isAuctionExpired(ClassicAuction memory auction) {
         require((auction.endTime < block.timestamp) && (auction.startTime > block.timestamp), "Auction has expired");
         _;
     }
     
     modifier auctionStarted(ClassicAuction memory auction) {
         require(block.timestamp > auction.startTime && block.timestamp < auction.endTime, "Auction not running");
         _;
     }
         
    modifier auctionDoesntExistsForNFTId(uint nftId) {
        bool auctionIndexFound = false;
        for (uint i = 0; i < _allAuctions.length; i++) {
            if (_allAuctions[i].nftId == nftId) {
                i = _allAuctions.length;
                auctionIndexFound = true;
            }
        }
        require(!auctionIndexFound, "Auction Already Exists");
        _;
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
     
     modifier hasEnoughWolvercoin(uint amount) {
         require(_wolvercoin.balanceOf(msg.sender) > amount, "Insufficient wolvercoin balance");
         _;
     }
     
     /*  // Pay wolvercoin to contract (transferFrom)
     *  6 Create a method to transfer a certain uint256 value of wolvercoin to this contract 
     *      a. Should transfer wolvercoin from their address
     *      b. This address is address(this)
     *      c. Either fails or returns false, up to you.  B smart
     */
     function transferWovercoinToContract(uint256 wolvercoinAmount) internal 
        hasEnoughWolvercoin(wolvercoinAmount)
        isApprovedForWolvercoin(wolvercoinAmount) {
            _wolvercoin.transferFrom(msg.sender, address(this), wolvercoinAmount);
    }

    // Need to refund wolvercoin to previous bidder
    function refundWovercoinToPreviousBidder(uint256 wolvercoinAmount, address previousBidder) internal {
         _wolvercoin.transferFrom(address(this), previousBidder, wolvercoinAmount);
     }
     
     /*  // Pay wolvercoin to highest bidder
     *  6.1 Create a method to pay an Auction's highestBidder from this contract (transfer)
     */
     function transferNftAndPayAuctionHighestBidderAndRemoveAuction(ClassicAuction memory auction) internal {
         _wolvercoinNFTs.transferFrom(address(this), auction.highestBidder, auction.nftId);
         
         // ERC20 - transferFrom(address sender, address recipient, uint256 amount) → bool
         _wolvercoin.transferFrom(address(this), auction.highestBidder, auction.highestBid);
         
         // 
         uint256 auctionIndex = getAuctionIndexByNftId(auction.nftId);
         _finishedAuctions.push(_allAuctions[auctionIndex]);
         removeAuctionByIndex(auctionIndex);
         
     }
     
     
    function _setNFT(address _nft) public onlyOwner {
        _wolvercoinNFTs = IERC721(_nft);
    }

}