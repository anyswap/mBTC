var SwapAsset = artifacts.require("BtcSwapAsset");

module.exports = function(deployer) {
  deployer.deploy(SwapAsset);
};
