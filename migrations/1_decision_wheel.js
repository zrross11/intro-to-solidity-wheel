const DecisionWheel = artifacts.require("DecisionWheel");

module.exports = function(deployer) {
  deployer.deploy(DecisionWheel);
};
