var whichDeploy = "Btc"

if (whichDeploy == "Btc") {
  // deploy BtcSwapAsset
  var BtcSwapAsset = artifacts.require("BtcSwapAsset");

  module.exports = function(deployer) {
    deployer.deploy(BtcSwapAsset);
  };
} else if (whichDeploy == "Eth") {
  // deploy EthSwapAsset
  var EthSwapAsset = artifacts.require("EthSwapAsset");

  module.exports = function(deployer) {
    deployer.deploy(EthSwapAsset);
  };
} else if (whichDeploy == "Erc20") {
  // deploy Erc20SwapAsset
  var Erc20SwapAsset = artifacts.require("Erc20SwapAsset");

  // custom according to the Erc20 contract
  var erc20Symbol = "USDT"
  var erc20Decimals = 8

  var name = "SMPC " + erc20Symbol
  var symbol = "m" + erc20Symbol
  var decimals = erc20Decimals
  module.exports = function(deployer) {
    deployer.deploy(Erc20SwapAsset, name, symbol, decimals);
  };
}
