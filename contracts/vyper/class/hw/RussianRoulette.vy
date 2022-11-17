# RussianRoulette Version 1
players: public(address[100])
losers: public(address[100])
odds: public(uint256)
playersTurn: public(uint256)
creator: public(address)

@external
def __init__():
    self.creator = msg.sender

@external
def setOdds(oneInThisMany: uint256):

    # Make sure the contract creator is runing this method
    assert msg.sender == self.creator

    self.odds = oneInThisMany

