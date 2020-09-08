pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract BtcSwapAsset is ERC20, ERC20Detailed {
    event LogChangeDCRMOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveHeight);
    event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
    event LogSwapout(address indexed account, uint amount, string bindaddr);

    address private _oldOwner;
    address private _newOwner;
    uint256 private _newOwnerEffectiveHeight;

    modifier onlyOwner() {
        require(msg.sender == owner(), "only owner");
        _;
    }

    constructor() public ERC20Detailed("ANY Bitcoin", "anyBTC", 8) {
        _newOwner = msg.sender;
        _newOwnerEffectiveHeight = block.number;
    }

    function owner() public view returns (address) {
        if (block.number >= _newOwnerEffectiveHeight) {
            return _newOwner;
        }
        return _oldOwner;
    }

    function changeDCRMOwner(address newOwner) public onlyOwner returns (bool) {
        require(newOwner != address(0), "new owner is the zero address");
        _oldOwner = owner();
        _newOwner = newOwner;
        _newOwnerEffectiveHeight = block.number + 13300;
        emit LogChangeDCRMOwner(_oldOwner, _newOwner, _newOwnerEffectiveHeight);
        return true;
    }

    function Swapin(bytes32 txhash, address account, uint256 amount) public onlyOwner returns (bool) {
        _mint(account, amount);
        emit LogSwapin(txhash, account, amount);
        return true;
    }

    function Swapout(uint256 amount, string memory bindaddr) public returns (bool) {
        verifyBindAddr(bindaddr);
        _burn(_msgSender(), amount);
        emit LogSwapout(_msgSender(), amount, bindaddr);
        return true;
    }

    function verifyBindAddr(string memory bindaddr) pure internal {
        uint length = bytes(bindaddr).length;
        require(length >= 26, "address length is too short");

        byte ch = bytes(bindaddr)[0];

        if (ch == '1' || ch == '3') {
            require(length <= 34, "mainnet address length is too long");
        } else if (ch == '2' || ch == 'm' || ch == 'n') {
            require(length <= 35, "testnet address length is too long");
        } else {
            require(false, "unsupported address leading symbol");
        }
    }
}
