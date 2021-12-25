const AwesomeTokenNew = artifacts.require("AwesomeTokenNew");

module.exports = function (deployer) {
  deployer.deploy(AwesomeTokenNew, 1000000000, "AwesomeTNew", "AWTN");
};
