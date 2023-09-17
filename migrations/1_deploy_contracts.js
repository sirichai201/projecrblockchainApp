const MyContractBlockchain = artifacts.require("MyContractBlockchain");


module.exports = function (deployer) {
    deployer.deploy(MyContractBlockchain);
};