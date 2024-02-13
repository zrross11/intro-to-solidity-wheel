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
        
    Decision[] public decisions;
        
    event DecisionMade(string question, string answer, address decisionMaker, uint256 timestamp);
        
    function makeDecision(string memory question, string[] memory answers) public {
        require(answers.length > 1, "At least two answers must be provided");
            
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % answers.length;
        string memory winningAnswer = answers[randomIndex];
            
        Decision memory newDecision = Decision(question, winningAnswer, msg.sender, block.timestamp);
            
        if (decisions.length == 5) {
            // Shift the elements of the array to the left, overwriting the first element and leaving the last element empty
            for (uint i = 0; i < decisions.length - 1; i++) {
                decisions[i] = decisions[i + 1];
            }
            // Set the last element to the new decision
            decisions[decisions.length - 1] = newDecision;
        } else {
            decisions.push(newDecision);
        }
            
        emit DecisionMade(question, winningAnswer, msg.sender, block.timestamp);
    }
}