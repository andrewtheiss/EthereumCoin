// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./includes/ERC721.sol";

// https://solidity-by-example.org/app/english-auction/
// https://solidity-by-example.org/app/dutch-auction/
// https://github.com/brynbellomy/solidity-auction/blob/master/contracts/Auction.sol

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
           // nft.transfer(highestBidder, nftId);
            nft.transferFrom(seller, highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            //nft.transfer(seller, nftId);
            nft.transferFrom(seller, highestBidder, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}


contract DutchAuction {
    event Buy(address winner, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public seller;
    uint public startingPrice;
    uint public startAt;
    uint public expiresAt;
    uint public priceDeductionRate;
    address public winner;

    constructor(
        uint _startingPrice,
        uint _priceDeductionRate,
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + 7 days;
        priceDeductionRate = _priceDeductionRate;

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");
        require(winner == address(0), "auction finished");

        uint timeElapsed = block.timestamp - startAt;
        uint deduction = priceDeductionRate * timeElapsed;
        uint price = startingPrice - deduction;

        require(msg.value >= price, "ETH < price");

        winner = msg.sender;
        nft.transferFrom(seller, msg.sender, nftId);
        seller.transfer(msg.value);

        emit Buy(msg.sender, msg.value);
    }
}

// Test simple win auction
contract WinAuction {
    
    event Win(address winner, uint256 amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    address public winner;

    constructor() {
        seller = payable(msg.sender);
    }
    
    function setNFT(address _nft, uint _nftId) public {
        nft = IERC721(_nft);
        nftId = _nftId;
    }

    // Wins the auction for the specified amount
    function win() external payable {
        winner = msg.sender;
        nft.safeTransferFrom(address(this), msg.sender, nftId);
        seller.transfer(msg.value);

        emit Win(msg.sender, msg.value);
    }
}