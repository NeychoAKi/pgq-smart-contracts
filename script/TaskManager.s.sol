// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import "../src/TaskManager.sol";

contract TaskManagerScript is Script {
    TaskManager public taskManager;

    function setUp() public {}

    function run() public {
        uint deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        address petToken = 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853;
        address skillContract = 0x0165878A594ca255338adfa4d48449f69242Eb8F;
        taskManager = new TaskManager(petToken, skillContract);

        vm.stopBroadcast();
    }
}

// forge script script/TaskManager.s.sol:TaskManagerScript --rpc-url $RPC_URL --broadcast
// 0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6
