// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./includes/IERC20.sol";
import "./includes/SafeMath.sol";
import "hardhat/console.sol";

// Upgradable libraries.  
// UUPS makes sure the upgradeTo method is always available
// Initializable takes care of contructor alternative behavior
import "./includes/UUPSUpgradeable.sol";
import "./includes/Initializable.sol";
import './includes/Owner.sol';
import "./includes/ERC20Upgradeable.sol";
import "./includes/OwnableUpgradeable.sol";
import "./includes/ContextUpgradeable.sol";

/** 
 * TODO:
 *  Make sure it's upgradable:
 *      TODO: Upgradable requires we remove ALL selfdestruct, delegatecall and constructors
 *  Make owner transferrable
 *  Document and detail token details
 *  
 */
//contract HWC is Owner, Initializable, ContextUpgradeable, ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable {
contract HWC is Initializable, ERC20Upgradeable {

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The defaut value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    function initialize() initializer public {

      __ERC20_init("Harvard-Westlake Coin", "HWC");
      
      _mint(msg.sender, 1000 * 10 ** decimals());
    }

    /**
     * @dev Overwrite upgradable 
     */
    //function _authorizeUpgrade(address) internal override onlyOwner {}

}