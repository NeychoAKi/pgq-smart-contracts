// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {Skill} from "../src/Skill.sol";

contract SkillScript is Script {
    Skill public skill;

    function setUp() public {}

    function run() public {
        uint deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        skill = new Skill();

        vm.stopBroadcast();
    }
}

// forge script script/Skill.s.sol:SkillScript --rpc-url $RPC_URL --broadcast --verify -vvvv
// forge script script/Skill.s.sol:SkillScript --rpc-url $RPC_URL --broadcast
// 0x5FbDB2315678afecb367f032d93F642f64180aa3
// cast send --private-key $PRIVATE_KEY 0x5FbDB2315678afecb367f032d93F642f64180aa3
// cast send --private-key $PRIVATE_KEY 0x5FbDB2315678afecb367f032d93F642f64180aa3 "setUpgradeThreshold(uint256 skillId, uint256 threshold)" 1 100
// cast send --private-key $PRIVATE_KEY 0x5FbDB2315678afecb367f032d93F642f64180aa3 "updateSkill(address user, uint256 skillId, uint256 progressIncrease)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 1 130
// cast call --private-key $PRIVATE_KEY 0x5FbDB2315678afecb367f032d93F642f64180aa3 "getSkill(address user, uint256 skillId)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 1
// setUpgradeThreshold(uint256 skillId, uint256 threshold)
