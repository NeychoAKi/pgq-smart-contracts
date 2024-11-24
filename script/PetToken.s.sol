// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {PetToken} from "../src/PetToken.sol";

contract PetTokenScript is Script {
    PetToken public petToken;

    function setUp() public {}

    function run() public {
        uint deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        petToken = new PetToken(10000);

        vm.stopBroadcast();
    }
}

// forge script script/PetToken.s.sol:PetTokenScript --rpc-url $RPC_URL --broadcast
// 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853
