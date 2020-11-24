# compile params

## remix version

use remix: 
<https://remix.ethereum.org/#optimize=true&evmVersion=null&version=soljson-v0.5.4+commit.9549d8ff.js&runs=200>

## solc version

0.5.4+commit.9549d8ff.Emscripten.clang

## optimize

Enable optimization

## compile

compile from single file in `contracts` directory, and retrieve the compiled bytecode (prepend 0x)

```text
contracts/BtcSwapAssetV2.sol --> anyBTC-v2.txt
contracts/Erc20SwapAsset.sol --> anyERC20.txt
contracts/LtcSwapAssetV2.sol --> anyLTC.txt
```

## MIT license

