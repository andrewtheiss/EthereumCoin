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
}

