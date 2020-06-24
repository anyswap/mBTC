pragma solidity ^0.5.0;

import "./ERC20/ERC20.sol";

contract UsdtSwapAsset is ERC20 {
    event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
    event LogSwapout(address indexed account, uint amount);

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() public ERC20("SMPC ERC20 USDT", "mUSDT") {
        owner = msg.sender;
        _setupDecimals(6);
    }

    function Swapin(bytes32 txhash, address account, uint256 amount) public onlyOwner returns (bool) {
        _mint(account, amount);
        emit LogSwapin(txhash, account, amount);
        return true;
    }

    function Swapout(uint256 amount) public returns (bool) {
        _burn(_msgSender(), amount);
        emit LogSwapout(_msgSender(), amount);
        return true;
    }
}
