// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./interface/ISkill.sol";


contract TaskManager {

    address private immutable admin;
    IERC20 private immutable petToken;
    ISkill private immutable skillContract;

    struct TaskReward {
        uint256 skillId;
        uint256 petTokens;
        uint256 experience;
    }

    // 任务ID -> 任务信息
    mapping (uint256 => TaskReward) public taskRewards;
    // 用户地址 -> 任务ID -> 是否完成
    mapping (address => mapping (uint256 => bool)) public userTaskCompletion;
    // 用户任务奖励领取状态
    mapping (address => mapping (uint256 => bool)) public userRewardClaimed;

    event TaskCompleted(address indexed user, uint256 indexed taskId, uint256 score, uint256 timestamp);
    event RewardClaimed(address indexed user, uint256 indexed taskId, uint256 petTokens, uint256 indexed skillId, uint256 experience);
    event TaskRewardSet(uint256 indexed skillId, uint256 indexed taskId, uint256 petTokens,  uint256 experience);

    constructor(address _petToken, address _skillContract) {
        admin = msg.sender;
        petToken = IERC20(_petToken);
        skillContract = ISkill(_skillContract);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    /*
        后端预处理+哈希存储： 后端计算任务数据的 Merkle Tree 根节点，并存储到链上，用户在领取奖励时提供证明。示例流程：
        1. 后端生成任务数据的 Merkle Tree。
        2. 将根节点存储在合约中。
        3. 用户领取奖励时提交证明，合约验证通过后发放奖励。
    */
    function setTaskReward(
        uint256[] calldata taskIds,
        uint256[] calldata petTokens,
        uint256[] calldata skillIds,
        uint256[] calldata experiences
    ) external {
        require(
            taskIds.length == petTokens.length &&
            taskIds.length == skillIds.length &&
            taskIds.length == experiences.length,
            "Input arrays must have the same length"
        );

        for (uint256 i = 0; i < taskIds.length; i++) {
            require(skillIds[i] != 0, "Invalid SkillId");
            taskRewards[taskIds[i]] = TaskReward(
                skillIds[i],
                petTokens[i],
                experiences[i]
            );
            emit TaskRewardSet(skillIds[i], taskIds[i], petTokens[i], experiences[i]);
        }
    }

    // 用户完成任务
    function completeTask(uint256 taskId, uint256 score) public {
        require(!userTaskCompletion[msg.sender][taskId], "Task already completed");

        userTaskCompletion[msg.sender][taskId] = true;

        emit TaskCompleted(msg.sender, taskId, score, block.timestamp);
    }

    // 用户领取奖励
    function claimReward(uint256 taskId) public {
        require(userTaskCompletion[msg.sender][taskId], "Task not completed");
        require(!userRewardClaimed[msg.sender][taskId], "Reward already claimed");

        TaskReward memory reward = taskRewards[taskId];
        require(reward.skillId != 0, "Invalid taskId");

        // 记录奖励领取
        userRewardClaimed[msg.sender][taskId] = true;

        // 具体奖励投放（宠物代币+成长值）
        require(petToken.transfer(msg.sender, reward.petTokens), "Pet token transfer failed");
        skillContract.updateSkill(msg.sender, reward.skillId, reward.experience);

        emit RewardClaimed(msg.sender, taskId, reward.petTokens, reward.skillId, reward.experience);
    }
}
