// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./includes/ERC721.sol";
import "./WolverAuctions.sol";

contract Wolvercoin_NFT is ERC721 {
    
    // Add Auction Capability
    WinAuction[] winAuctions;
    
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        _safeMint(to, tokenId, _data);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }
    /*
    function createDutchAuction(uint256 _startingPrice, uint256 _priceDeductionRate, address _nft, uint256 _nftId) public {
        DutchAuction d = new DutchAuction(_startingPrice, _priceDeductionRate, _nft, _nftId);
        dutchAuctions.push(d);
    }
    */
}
