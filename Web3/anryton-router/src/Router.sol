// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import Chainlink Automation Interfaces
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

contract Router is KeeperCompatibleInterface {
    // Structure to Store Gas Price and Timestamp for each Node
    struct Node {
        uint256 gasPrice;
        uint256 lastUpdated;
    }

    // State Variables
    mapping(address => Node) public nodes;
    address[] public nodeList;
    address public owner;

    // Automation Variables
    uint256 public lastTimeStamp;
    uint256 public interval = 12; // Every 12 seconds

    // Events
    event GasPriceUpdated(address indexed node, uint256 gasPrice);
    event AutomationTriggered(uint256 timestamp);

    // Modifier to Restrict Access to Owner Only
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Constructor - Sets the Contract Owner and Initial Timestamp
    constructor() {
        owner = msg.sender;
        lastTimeStamp = block.timestamp;
    }

    // Record Gas Prices in Batch (Only Owner or Trusted Oracles)
    function batchRecordGasPrice(address[] memory nodesInput, uint256[] memory gasPrices) public onlyOwner {
        require(nodesInput.length == gasPrices.length, "Mismatched inputs");

        for (uint256 i = 0; i < nodesInput.length; i++) {
            // If it's a new node, add to nodeList
            if (nodes[nodesInput[i]].lastUpdated == 0) {
                nodeList.push(nodesInput[i]);
            }
            // Record Gas Price for each Node
            nodes[nodesInput[i]] = Node(gasPrices[i], block.timestamp);
        }
    }

    // Chainlink Automation: Checks if the upkeep is needed
    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    // Chainlink Automation: Performs the upkeep
    function performUpkeep(bytes calldata) external override {
        if ((block.timestamp - lastTimeStamp) > interval) {
            lastTimeStamp = block.timestamp;

            // Call the batchRecordGasPrice function to record gas prices
            address;
            nodesInput[0] = 0x0000000000000000000000000000000000000001;
            nodesInput[1] = 0x0000000000000000000000000000000000000002;
            
            uint256;
            gasPrices[0] = 100;
            gasPrices[1] = 80;
            
            batchRecordGasPrice(nodesInput, gasPrices);

            emit AutomationTriggered(block.timestamp);
        }
    }

    // Update Interval (Only Owner)
    function updateInterval(uint256 newInterval) external onlyOwner {
        interval = newInterval;
    }
}
