const SeverToken = artifacts.require("SeverToken");
const MigrationAgentSever = artifacts.require("MigrationAgentSever");
const AwesomeTokenNew = artifacts.require("AwesomeTokenNew");

module.exports = function (deployer) {
  deployer.deploy(SeverToken, "SeverToken", "ST");
  deployer.deploy(MigrationAgentSever, AwesomeTokenNew.address);
};
