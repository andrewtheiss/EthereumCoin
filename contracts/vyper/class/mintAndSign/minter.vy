# look into interface import https://vyper.readthedocs.io/en/stable/interfaces.html

users: public(HashMap[address, uint256])
teachers: HashMap[address, bool]
allowance: uint256

# interface with ERC20 Wolvercoin
interface Wolvercoin:
    def  mint(_to:address , _value: uint256): nonpayable
    def test1(): nonpayable

@external
def __init__():
    self.teachers[msg.sender] = True
    self.allowance = 10

@external
def addUser(coinUserToAdd: address) -> (bool):

    # only allow teachers to add another user
    assert self.teachers[msg.sender] == True

    return False

@external
def bulkMintToken(wolvercoin: Wolvercoin, users: address[5]):
    for i in range(5):
        if users[i] != empty(address):
            wolvercoin.mint(users[i], self.allowance)