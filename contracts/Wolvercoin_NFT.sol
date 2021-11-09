// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./includes/Owner.sol";
import "./includes/ERC721Enumerable.sol";

contract Wolvercoin_NFT is Owner, ERC721Enumerable{
  
    // We want to allow students to help mint objects but then stop 
    // giving them permission after sometime.  So we set and salt a 
    // password to give access
    uint password;
  
    constructor(string memory name, string memory symbol, string memory _password) ERC721(name, symbol) {
        password = _saltPassword(_password);
    }

    
    function safeMintAsOwner(address to, uint256 tokenId) public isOwner {
        _safeMint(to, tokenId);
    }
    
    function safeMintToContractAsOwner(uint256 tokenId) public isOwner {
        _safeMint(address(this), tokenId);
        _setTokenUri("test", "test");
    }
    
        
    // Modifiers can take inputs. This modifier checks that the
    // user used a correct password
    modifier usesPassword(string memory _password) {
        require(password == _saltPassword(_password), "Incorrect Password");
        _;
    }

    // Take the password input and salts it 
    function _saltPassword(string memory _password) private pure returns (uint) {
        uint pwd = uint(keccak256(abi.encode(_password)));
        uint salt = uint(keccak256(abi.encode("Email 'OMGWTFBBQ' 1st 2Mr.Theiss4exCred")));
        return (pwd + salt);
    }
    
    // Sets a new password, if we are the owner only!
    function setPassword(string memory _password) public isOwner returns (bool) {
        password = _saltPassword(_password);
        return true;
    }
    
    /**
     * Override isApprovedForAll to auto-approve for Mr. Theiss (for now)
     */
    function isApprovedForAll(
        address _owner,
        address _operator
    ) public override view returns (bool isOperator) {
      // if OpenSea's ERC721 Proxy Address is detected, auto-return true
        if (_operator == address(0x9c3C6ff39f65689ED820476362615a347bB23b3F)) {
            return true;
        }
        
        // otherwise, use the default ERC721.isApprovedForAll()
        return ERC721.isApprovedForAll(_owner, _operator);
    }
}

