const DecisionWheel = artifacts.require("DecisionWheel");

contract("DecisionWheel", accounts => {
    it("should make a decision", async () => {
        const decisionWheelInstance = await DecisionWheel.deployed();
        await decisionWheelInstance.makeDecision("Should I go to the gym?", ["Yes", "No"], { from: accounts[0] });

        const decision = await decisionWheelInstance.decisions(0);
        assert.equal(decision.question, "Should I go to the gym?");
        console.log(decision)
        assert(["Yes", "No"].includes(decision.answer));
        assert(decision.timestamp > 0, "Timestamp should be greater than 0");
    });
});