// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./includes/IERC20.sol";
import "./includes/SafeMath.sol";
import "./includes/UUPSUpgradeable.sol";
import "./includes/Initializable.sol";
import './includes/Owner.sol';
import "./includes/ERC1155Upgradeable.sol";
import "./includes/OwnableUpgradeable.sol";
import "./includes/ContextUpgradeable.sol";
import "./includes/ERC165Upgradeable.sol";
import "./includes/ERC165Upgradeable.sol";

// https://docs.openzeppelin.com/contracts/3.x/erc1155
// https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable
/*
 * TODO:
 *  Make sure it's upgradable:
 *  TODO : include UUPS https://forum.openzeppelin.com/t/uups-proxies-tutorial-solidity-javascript/7786
 *      https://docs.openzeppelin.com/learn/upgrading-smart-contracts
 *      https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable
 *  Weigh minting and fair launch vs max total supply and distribution  
 *  Make owner transferrable
 * 
import "@openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol";

 contract MyContract is ERC1155Holder 
 Example ERC1155 https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/presets/ERC1155PresetMinterPauser.sol
 *  
 */
contract HWC is Initializable, ContextUpgradeable, ERC1155Upgradeable, UUPSUpgradeable, OwnableUpgradeable  {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    
    uint256 private _totalSupply;
    string private _name;  // Removed and moved to json file
    string private _symbol;
    uint8 private _decimals;
    address private _admin;
    
    // A nonce to ensure we have a unique id each time we mint.
    uint256 public nonce;
    
    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;
    
    // Save space for class periods so we can give coin to entire periods at once
    address[][7] public _periods1_to_7;
    
    // Constructors are replaced by internal initializer functions following the naming convention
    //  __{ContractName}_init. Since these are internal, you must always define your own public 
    // initializer function and call the parent initializer of the contract you extend.
    function initialize() initializer public {
       __ERC1155_init("Uri");
       _admin = msg.sender;
       //_mint(msg.sender, 1000 * 10 ** _decimals);
    }
    
    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `PAUSER_ROLE` to the account that
     * deploys the contract.
     */
    function __ERC1155_init(string memory uri) internal initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __AccessControl_init_unchained();
        __AccessControlEnumerable_init_unchained();
        __ERC1155_init_unchained(uri);
        __ERC1155Burnable_init_unchained();
        __Pausable_init_unchained();
        __ERC1155Pausable_init_unchained();
        __ERC1155PresetMinterPauser_init_unchained(uri);
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
        _totalSupply = 620000000000;  // 62 Billion with 18 decimals
        
        // Create 10k supply for initial creator
       // _mint(msg.sender, 10000);
    }
    
    
    /// TODO ////////////// PUT ALL CLASS PERIOD CODE INTO INCLUDE FILE //////////////
    // Save max 7 class periods
    // Need to store class lists so that we can distribute tokens to an entire class at a time
    address[][7] _addressesForClassPeriod;
    
    function addAddressForClassPeriod(uint256 period, address _address) public {
        require(msg.sender == _admin, "HWCoin : Not admin");
        _addressesForClassPeriod[period].push(_address);
    }
        
    function getAllAddressesForClassPeriod(uint256 period) public view returns (address[] memory) {
        return _addressesForClassPeriod[period];
    }
    //////////////// END CLASS CODE ////////////////////////
    
    
    // Emitted when the stored value changes
    event ValueChanged(uint256 value);
    
    // Required for UUPSUpgradeable
    function _authorizeUpgrade(address) internal view override {
        require(msg.sender == _admin, "HWCoin : Not admin");
        
    }
    
    
    
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
        return
            interfaceId == type(IERC1155Upgradeable).interfaceId ||
            interfaceId == type(IERC1155MetadataURIUpgradeable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address");
        return _balances[id][account];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(_msgSender() != operator, "ERC1155: setting approval status for self");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }



    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }
    
     function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155ReceiverUpgradeable(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
                bytes4 response
            ) {
                if (response != IERC1155ReceiverUpgradeable.onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }


    uint256[47] private __gap;

}