// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./Skill.sol";

contract TaskManager {

    address private immutable admin;
    IERC20 private immutable petToken;
    Skill private immutable skillContract;

    struct TaskReward {
        uint256 petTokens;
        uint256 skillId;
        uint256 skillProgress;
    }

    mapping (uint256 => TaskReward) public taskRewards;

    // 用户地址 -> 任务ID -> 是否完成  
    mapping (address => mapping (uint256 => bool)) public userTaskCompletion;
    // 用户任务奖励领取状态
    mapping (address => mapping (uint256 => bool)) public userRewardClaimed;

    event TaskCompleted(address indexed user, uint256 indexed taskId);
    event RewardClaimed(address indexed user, uint256 indexed taskId, uint256 petTokens, uint256 skillId, uint256 skillProgress);

    constructor(address _petToken, address _skillContract) {
        admin = msg.sender;
        petToken = IERC20(_petToken);
        skillContract = Skill(_skillContract);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    function setTaskReward(uint256 taskId, uint256 petTokens, uint256 skillId, uint256 skillProgress) public {
        taskRewards[taskId] = TaskReward(petTokens, skillId, skillProgress);
    }

    // 用户完成任务
    function completeTask(uint256 taskId) public {
        require(!userTaskCompletion[msg.sender][taskId], "Task already completed");

        userTaskCompletion[msg.sender][taskId] = true;

        emit TaskCompleted(msg.sender, taskId);
    }

    // 用户领取奖励
    function claimReward(uint256 taskId) public {
        require(userTaskCompletion[msg.sender][taskId], "Task not completed");
        require(!userRewardClaimed[msg.sender][taskId], "Reward already claimed");
        
        require(taskRewards[taskId].skillId != 0, "Invalid taskId");
        TaskReward memory reward = taskRewards[taskId];

        // 记录奖励领取
        userRewardClaimed[msg.sender][taskId] = true;

        // 具体奖励投放（宠物代币+成长值）
        require(petToken.transfer(msg.sender, reward.petTokens), "Pet token transfer failed");
        skillContract.updateSkill(msg.sender, reward.skillId, reward.skillProgress);

        emit RewardClaimed(msg.sender, taskId, reward.petTokens, reward.skillId, reward.skillProgress);
    }                       
}