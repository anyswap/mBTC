module.exports = {

  networks: {
    development: {
      host: "127.0.0.1",
      port: 8701,
      network_id: 46688,
      gas: 4000000,
      gasPrice: 1000000000,
    },
  },

  compilers: {
    solc: {
      version: "0.5.10",
      evmVersion: "constantinople",
      settings: {
        optimizer: {
          enabled: true,
          runs: 1500,
        }
      }
    }
  }
}
