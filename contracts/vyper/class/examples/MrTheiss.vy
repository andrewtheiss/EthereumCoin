counter: public(uint256)
topSecretCounter : uint256

@external
def incrementCount(amount: uint256) -> (bool):

    # Don't allow the counter to increase by more than 6
    assert amount < 6

    self.counter += amount
    self.topSecretCounter += 1

    return True

@external
def getTopSecretCounter() -> (uint256, String[136]):

    if (self.topSecretCounter < 100):
        return (self.topSecretCounter, "The secret threshold hasn't been reached yet")

    if (self.topSecretCounter < 110):
        return (self.topSecretCounter, "Almost there")

    self.topSecretCounter = 0
    return (self.topSecretCounter, "Email atheiss@hw.com with subject: *COUNTER EXTRA CREDIT* first for credit.  Only valid once per class on or after demo of this contract")