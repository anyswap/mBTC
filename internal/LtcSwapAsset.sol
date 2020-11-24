pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract LtcSwapAsset is ERC20, ERC20Detailed {
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

    constructor() public ERC20Detailed("ANY Litcoin", "anyLTC", 8) {
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
        byte ch2 = bytes(bindaddr)[1];
        byte ch3 = bytes(bindaddr)[2];
        byte ch4 = bytes(bindaddr)[3];

// Mainnet
// p2pkh	base58		0x30	L		34
// p2sh		base58		0x32	M		34
// p2wpkh	bech32		0x06	ltc1q		43
// p2wsh	bech32		0x0A	ltc1q		63

//Testnet
// p2pkh	base58		0x6f	m or n		34
// p2sh		base58		0x3a	Q		34
// p2wpkh	bech32		0x52	tltc1q		43
// p2wsh	bech32		0x31	tltc1q		63

        if (ch == 'L' || ch == 'M') {
            require(length <= 34, "mainnet address length is too long");
        } else if (ch4 == '1' && ch == 'l' && ch2 == 't' && ch3 == 'c') {
            require(length == 43 || length == 63, "segwit address length is not 43 or 63");
        } else {
            require(false, "unsupported address leading symbol");
        }
    }
}
