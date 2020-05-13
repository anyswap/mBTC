module.exports = {

  networks: {
    development: {
      host: "5.189.139.168",
      port: 8018,
      network_id: 4,
      gas: 4000000,
      gasPrice: 1000000000,
    },
  },

  compilers: {
    solc: {
      version: "0.5.16",
      //evmVersion: "constantinople"
      settings: {
        optimizer: {
          enabled: true,
          runs: 1500
        }
      }
    }
  }
}
