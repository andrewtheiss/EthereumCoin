# @version ^0.2.0

highestBidder: public(address)
highestBid: public(uint256)

biddedPool: public(HashMap[address, uint256])
winner: public(address)



@external
def __init__():
    self.highestBidder = 


@external
def bid(bidAmount: uint256):
    if (bidAmount > )