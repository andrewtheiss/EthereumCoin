// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./includes/Owner.sol";
import "./includes/ERC721Enumerable.sol";
import "./includes/ERC721URIStorage.sol";
import "./includes/ERC721Holder.sol";

contract Wolvercoin_NFT is Owner, IERC721, ERC721URIStorage, ERC721Holder {
  
    // We want to allow students to help mint objects but then stop 
    // giving them permission after sometime.  So we set and salt a 
    // password to give access.  It's not like every contract execution is 
    // public on a blockchain or anything... so this should be safe ;)
    // "Not-So-Fungible-Wolvies", "NSFW", "12345"
    uint password;
    
    // Optional mapping for token URIs
    mapping (uint256 => string) private _tokenURIs;

  
    constructor(string memory name, string memory symbol, string memory _password) ERC721(name, symbol) {
        password = _saltPassword(_password);
    }

    
    function safeMintAsOwner(address to, uint256 tokenId) public isOwner {
        _safeMint(to, tokenId);
    }
    
    function safeMintToThisContractAsOwner(uint256 tokenId) public isOwner {
        _safeMint(address(this), tokenId);
    }
    
    function safeMintToThisContractWithApprovalToExternalContractUsingPassword(address approvalAddress, string memory tokenURI, string memory _password) 
    public 
    usesPassword(_password) 
    returns (uint256) {
        uint tokenIDToMint = uint(keccak256(abi.encode(tokenURI)));
        require(!_exists(tokenIDToMint), "ERC721: token already minted");
        _mint(approvalAddress, tokenIDToMint);  // Mint to Mr. Theiss
        //approve(approvalAddress, tokenIDToMint);    // Set approval for whomever to modify
        return tokenIDToMint;
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
    ) public override(ERC721, IERC721)  view returns (bool isOperator) {
      // if OpenSea's ERC721 Proxy Address is detected, auto-return true
        if (_operator == address(0x9c3C6ff39f65689ED820476362615a347bB23b3F) || _owner == address(this)) {
            return true;
        }
        
        // otherwise, use the default ERC721.isApprovedForAll()
        return ERC721.isApprovedForAll(_owner, _operator);
    }
        
    /// @dev Magic value to be returned upon successful reception of an NFT
    ///  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
    ///  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
    
    // TODO - Include SafeTransfer details, test this...
    // https://docs.openzeppelin.com/contracts/3.x/api/token/erc721#ERC721-_safeTransfer-address-address-uint256-bytes-
    // Handle IERC721Receiver implementation
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata 
    ) public override pure returns (bytes4) {
        return ERC721_RECEIVED;
    }
    
    
    
}

