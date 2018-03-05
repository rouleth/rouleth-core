# Rouleth Core

### First you will need to install

```
npm install -g ethereumjs-testrpc
npm install -g truffle

npm install truffle-hdwallet-provider --save
```

### Then you will need to configure

Copy secret.example.js to secret.js and modify the seed and infura token.

### Then to deploy to Ropsten use
```
truffle compile
truffle migrate --network ropsten --reset
```