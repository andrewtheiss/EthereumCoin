// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./includes/IERC20.sol";
import "./includes/SafeMath.sol";
import "./includes/UUPSUpgradeable.sol";
import "./includes/Initializable.sol";
import './includes/Owner.sol';
import "./includes/ERC20Upgradeable.sol";
import "./includes/OwnableUpgradeable.sol";
import "./includes/ContextUpgradeable.sol";
import "./includes/IERC721Receiver.sol";

/** 
 * TODO:
 *  Weigh minting and fair launch vs max total supply and distribution  
 *  Implement staking https://hackernoon.com/implementing-staking-in-solidity-1687302a82cf
 *  Document and detail token details
 */
contract Wolvercoin is Initializable, ContextUpgradeable, IERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable, IERC721Receiver  {
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _stakeholders;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    // Save max 7 class periods (store class lists so that we can distribute tokens to an entire class at a time)
    address[][7] _addressesForClassPeriod;
    
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address private _admin;
    
    // Save space for class periods so we can give coin to entire periods at once
    address[] public _teachers;
    address[] public _nextPayout;
    
    // Constructors are replaced by internal initializer functions following the naming convention
    //  __{ContractName}_init. Since these are internal, you must always define your own public 
    // initializer function and call the parent initializer of the contract you extend.
    function initialize() initializer public {
        OwnableUpgradeable.__Ownable_init();
       __ERC20_init("Wolvercoin", "WVC");
       _admin = msg.sender;
    }
     
    function __ERC20_init(string memory name, string memory symbol) internal initializer {
        __Context_init_unchained();
        __ERC20_init_unchained(name, symbol);
        __Ownable_init();
    }

    function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
        _totalSupply = 62000000000000000000000000000;  // 62 Billion with 18 decimals
        
        // Create 1k supply for initial creator
         _mint(msg.sender, 1000000000000000000000);
    }
    
    // Need to check for duplicates
    function addAddressForClassPeriod(uint256 period, address _address) public {
        require(msg.sender == _admin, "Wolvercoin : Not admin");
        
        // See if they are in the period already
        bool alreadyAdded = false;
        for (uint i = 0; i < _addressesForClassPeriod[period].length; i++) {
            if (_addressesForClassPeriod[period][i] == _address) {
                alreadyAdded = true; 
            }
        }
        
        // Only add if not already in period
        if (!alreadyAdded) {
            _addressesForClassPeriod[period].push(_address);
        }
    }
        
    function getAllAddressesForClassPeriod(uint256 period) public view returns (address[] memory) {
        return _addressesForClassPeriod[period];
    }
    
    // Remove all addresses for class period
    function removeAddressesForClassPeriod(uint256 period) public returns (address[] memory) {
        require(msg.sender == _admin, "Wolvercoin : Not admin");
        for (uint i = 0; i < _addressesForClassPeriod[period].length; i++) {
           _addressesForClassPeriod[period].pop();
        }
        return _addressesForClassPeriod[period];
    }
    
    // Remove addresses from class period
    function removeAddressFromClassPeriod(uint256 period, address _address) public returns (address[] memory) {
        require(msg.sender == _admin, "Wolvercoin : Not admin");
        
        // Only remove if theree are addresses in this class
        if (_addressesForClassPeriod[period].length > 0) {
            bool addressExists = false;
            uint256 addressToRemoveIndex = 0;
            for (uint i = 0; i < _addressesForClassPeriod[period].length; i++) {
                if (_addressesForClassPeriod[period][i] == _address) {
                    addressExists = true;
                    addressToRemoveIndex = i;   
                }
            }
            
            // Move the last 
            if (addressExists) {
                _addressesForClassPeriod[period][addressToRemoveIndex] = _addressesForClassPeriod[period][_addressesForClassPeriod[period].length - 1];
                _addressesForClassPeriod[period].pop();
            }
        }
        
        return _addressesForClassPeriod[period];
    }
    
    // Remove class period
    function sendCoinToClassPeriod(uint256 period, uint256 amount ) public {
        require(msg.sender == _admin, "Wolvercoin : Not admin");
        
        for (uint i = 0; i < _addressesForClassPeriod[period].length; i++) {
           _mint(_addressesForClassPeriod[period][i], amount);
        }
    }
    //////////////// END CLASS CODE ////////////////////////
    
    
    // Emitted when the stored value changes
    event ValueChanged(uint256 value);
    
    // Required for UUPSUpgradeable
    function _authorizeUpgrade(address) internal view override {
        require(msg.sender == _admin, "Wolvercoin : Not admin");
        
    }
    
    // TODO - Include SafeTransfer details, test this...
    // https://docs.openzeppelin.com/contracts/3.x/api/token/erc721#ERC721-_safeTransfer-address-address-uint256-bytes-
    // Handle IERC721Receiver implementation
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata 
    ) public override pure returns (bytes4) {
        return this.onERC721Received.selector ^ this.transfer.selector;
    }
    
    
    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
    
    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }
    
    

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
    uint256[45] private __gap;
    /**
     * @dev Overwrite upgradable 
     */
    //function _authorizeUpgrade(address) internal override onlyOwner {}

}