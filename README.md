# Swap Asset Contract

this is an example of creating a swap asset (ERC20) contract with required `Swapin` and `Swapout` methods for cross chain bridge.

please ref. to [CrossChain-Bridge](https://github.com/anyswap/CrossChain-Bridge).

## How to deploy contract using truffle

## 0. install @openzeppelin/contracts

```shell
npm install
```

### flatten contract

This has been already done. Mention here only for re-flatten if modified later.

```shell
mpm install -g truffle-flattener
truffle-flattener internal/BtcSwapAsset.sol | sed '/SPDX-License-Identifier:/d' | sed 1i'// SPDX-License-Identifier: MIT' > contracts/BtcSwapAsset.sol
truffle-flattener internal/EthSwapAsset.sol | sed '/SPDX-License-Identifier:/d' | sed 1i'// SPDX-License-Identifier: MIT' > contracts/EthSwapAsset.sol
truffle-flattener internal/UsdtSwapAsset.sol | sed '/SPDX-License-Identifier:/d' | sed 1i'// SPDX-License-Identifier: MIT' > contracts/UsdtSwapAsset.sol
truffle-flattener internal/Erc20SwapAsset.sol | sed '/SPDX-License-Identifier:/d' | sed 1i'// SPDX-License-Identifier: MIT' > contracts/Erc20SwapAsset.sol
```

### 1. Modify truffle config

[truffle-config.js](
https://github.com/anyswap/mBTC/blob/master/truffle-config.js)
 
 Normally, you may meed to modify the following items:
 
 `host`: the rpc host of the node  
 `port`: the rpc port of the node  
 `network_id`: the chain id

 ### 2. Add and modify contracts

 Add and modify contracts in `contracts` directory.

 like our example: [BtcSwapAsset.sol](https://github.com/anyswap/mBTC/blob/master/contracts/BtcSwapAsset.sol).

### 3. Add migrations to deploy contract

Add an `js` file to depoly contract in `migrations` directory.

like our example: [2_deploy_contracts.js](https://github.com/anyswap/mBTC/blob/master/migrations/2_deploy_contracts.js).

### 4. Compile contract

Use the following command to compile contracts:

```shell
truffle compile
```

or re-compile all contracts:

```shell
truffle compile --all
```

### 5. Deploy contract

#### 5.1 Deploy contract directly
Use the following command to deploy contract:

```shell
truffle migrate
```

or re-deploy contract:

```shell
truffle migrate --reset
```

We may want to perform a test or 'dry run' migration firstly:

```shell
truffle migrate --dry-run
```


#### 5.2 Deploy contract using DCRM

Because we need to build a raw contract creation transaction and sign this raw transaction using DCRM technology,

So we need the `bytecode` as the transaction input data to build a raw contract cteation transaction.

`bytecode` can be found in `./build/contracts/BtcSwapAsset.json`

#### 5.3 how to get bytecode of contract with constructor arguments

the `bytecode` in truffle built contracts is `runtime bytecode` which has not the constructor argument info.

we should append the packed constructor arguments data (like abi encoding) to the end of the `runtime bytecode`
to generage the `creation bytecode` which is used as contract creation transaction's input data.

the following is a way by attaching to full node:

```javascript
abi = ...
runtime_bytecode = ...
creation_bytecode = eth.contract(abi).getData(param1,param2,...lastparam,{from:eth.coinbase,data:runtime_bytecode})
```

### 6. Access the deployed contract

#### 6.1 Access from truffle terminal
We can access the above deployed contract in truffle console terminal. 

Firstly log into truffle console terminal:

```shell
truffle console
```

Then assign an variable `app` to the deployed contract instance:

```shell
BtcSwapAsset.deployed().then(function(instance){ app = instance; })
```

For convenience, we can also assign all local accounts to `accounts` variable:

```shell
web3.eth.getAccounts().then(function(result){ accounts = result })
```

Now we can access the methods and attributes of the deployed contract. 

For example,

```shell
app.Swapout("45678","2MxQaHFhqKgYyTgcJj8foYHbPJQLQxvXQjp",{from:accounts[1]})
```

#### 6.2 Access by attaching IPC file

after attached to the running node, we can access the contract by the following infos:

```shell
app = eth.contract(abi).at(contractAddress)
```

`abi` can be found in `./build/contracts/BtcSwapAsset.json` (after building)
