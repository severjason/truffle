const Migrations = artifacts.require("Migrations");
//const AwesomeToken = artifacts.require("AwesomeToken");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
 // deployer.deploy(AwesomeToken, 10000, "AwesomeT", "AWT");
};
