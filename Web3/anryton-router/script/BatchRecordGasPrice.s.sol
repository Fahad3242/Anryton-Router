// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/Router.sol";

contract BatchRecordGasPrice is Script {
    Router public router;

    // Nodes and Gas Prices to Record
    address[] public nodes = [
        0x0000000000000000000000000000000000000001,
        0x0000000000000000000000000000000000000002
    ];
    uint256[] public gasPrices = [100, 80];

    function setUp() public {
        // Deploy Router contract if not already deployed
        router = Router(payable(0x94a7a79C68A96f2550727F28DD9Fe9e396A5C080));
    }
function run() public {
    vm.startBroadcast();

    // Record Gas Prices Multiple Times as Separate Transactions
    for (uint256 i = 0; i < 5; i++) {
        router.batchRecordGasPrice(nodes, gasPrices);

        // Force a new transaction by rolling the block
        vm.roll(block.number + 1);
    }

    vm.stopBroadcast();
}


}
