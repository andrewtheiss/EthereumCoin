# @version ^0.2.0

highestBidder: public(address)
highestBid: public(uint256)
biddingEnd: public(uint256)

biddedPool: public(HashMap[address, uint256])
winner: public(address)



@external
def __init__(totalTime : uint256):
    self.highestBidder = 0x0000000000000000000000000000000000000000
    self.highestBid = 0
    self.biddingEnd = block.timestamp + totalTime

@external
@payable
def bid(bidAmount: uint256):

    # Check a bunch of conditions
    assert block.timestamp < self.biddingEnd

    # Set bid
    if bidAmount > self.highestBid:
        self.highestBid = bidAmount
        self.highestBidder = msg.sender