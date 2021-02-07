pragma solidity >=0.5.0;

contract ProxySwapCoin {
    event LogChangeMPCOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveTime);
    event LogChangeLpProvider(address indexed oldProvider, address indexed newProvider);
    event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
    event LogSwapout(address indexed account, address indexed bindaddr, uint amount);

    address private _oldOwner;
    address private _newOwner;
    uint256 private _newOwnerEffectiveTime;
    uint256 constant public effectiveInterval = 2 * 24 * 3600;

    address public lpProvider;

    modifier onlyOwner() {
        require(msg.sender == owner(), "only owner");
        _;
    }

    modifier onlyProvider() {
        require(msg.sender == lpProvider, "only lp provider");
        _;
    }

    constructor(address _lpProvider) public {
        lpProvider = _lpProvider;
        _newOwner = msg.sender;
        _newOwnerEffectiveTime = block.timestamp;
    }

    function owner() public view returns (address) {
        return block.timestamp >= _newOwnerEffectiveTime ? _newOwner : _oldOwner;
    }

    function changeMPCOwner(address newOwner) public onlyOwner returns (bool) {
        require(newOwner != address(0), "new owner is the zero address");
        _oldOwner = owner();
        _newOwner = newOwner;
        _newOwnerEffectiveTime = block.timestamp + effectiveInterval;
        emit LogChangeMPCOwner(_oldOwner, _newOwner, _newOwnerEffectiveTime);
        return true;
    }

    function changeLpProvider(address newProvider) public onlyProvider returns (bool) {
        require(newProvider != address(0), "new provider is the zero address");
        emit LogChangeLpProvider(lpProvider, newProvider);
        lpProvider = newProvider;
    }

    // deposit fallback
    function () external payable {
    }

    function withdraw(address payable to, uint256 amount) public onlyProvider {
        to.transfer(amount);
    }

    function Swapin(bytes32 txhash, address payable account, uint256 amount) public onlyOwner returns (bool) {
        account.transfer(amount);
        emit LogSwapin(txhash, account, amount);
        return true;
    }

    // keep same interface with 'amount' parameter though it's unnecessary here
    function Swapout(uint256 amount, address bindaddr) public payable returns (bool) {
        require(bindaddr != address(0), "bind address is the zero address");
        require(msg.value == amount, "amount mismatch");
        emit LogSwapout(msg.sender, bindaddr, amount);
        return true;
    }
}
