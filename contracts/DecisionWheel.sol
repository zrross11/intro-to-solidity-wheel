// DecisionWheel.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DecisionWheel
 * @dev A contract that represents a decision wheel where users can input options, assign equal weight to each option,
 * and then randomly pick one option as the winner.
 */

contract DecisionWheel {

    struct Decision {
        string question;
        string answer;
        address decisionMaker;
        uint256 timestamp;
    }

    uint256 public currentDecisionIndex = 0;
    Decision[5] public decisions;

    event DecisionMade(string question, string answer, address decisionMaker, uint256 timestamp);
        
    function getDecisions() public view returns (Decision[5] memory) {
        return decisions;
    }

    function makeDecision(string memory question, string[] memory answers) public {
        require(answers.length > 1, "At least two answers must be provided");
            
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % answers.length;
        string memory winningAnswer = answers[randomIndex];
            
        decisions[currentDecisionIndex] = Decision(question, winningAnswer, msg.sender, block.timestamp);
            
        if (currentDecisionIndex < 4) {
            currentDecisionIndex++;
        } else {
            currentDecisionIndex = 0;
        }
            
        emit DecisionMade(question, winningAnswer, msg.sender, block.timestamp);
    }
}