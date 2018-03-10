var secret = require("./secret");
var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    networks: {
        ropsten: {
            provider: new HDWalletProvider(secret.mnemonic, "https://ropsten.infura.io/" + secret.infuraToken),
            network_id: '3',
            gas: 4000000,
            gasPrice: 20000000000 // 20 gwei
        },
        development: {
            host: "192.168.0.103",
            port: "7545",
            network_id: "5777", // Match any network id
            gas: 4000000,
            gasPrice: 20000000000 // 20 gwei
        }
    }
};
