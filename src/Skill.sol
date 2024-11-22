// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Skill {

    struct SkillInfo {
        uint256 progress;
        uint256 level;
    }

    // 用户技能信息
    mapping (address => mapping (uint256 => SkillInfo)) private userSkills;
    // 技能升级阈值
    mapping (uint256 => uint256) public skillUpgradeThresholds;

    // 自定义错误
    error ThresholdNotSet(uint256 skillId);
    error InvalidThreshold(uint256 skillId, uint256 threshold);

    // 事件
    event SkillUpdated(address indexed user, uint256 indexed skillId, uint256 newProgress, uint256 newLevel);
    event SkillUpgradeThresholdSet(uint256 indexed skillId, uint256 threshold);

    // 设置技能阈值
    function setUpgradeThreshold(uint256 skillId, uint256 threshold) public {
        if (threshold == 0) {
            revert InvalidThreshold(skillId, threshold);
        }

        skillUpgradeThresholds[skillId] = threshold;
        emit SkillUpgradeThresholdSet(skillId, threshold);
    }

    // 更新技能进度
    function updateSkill(address user, uint256 skillId, uint256 progressIncrease) public {
        // 检查是否设置了技能阈值
        if (skillUpgradeThresholds[skillId] == 0) {
            revert ThresholdNotSet(skillId);
        }

        SkillInfo storage skill = userSkills[user][skillId];

        skill.progress += progressIncrease;

        uint256 threshold = skillUpgradeThresholds[skillId];
        if (skill.progress >= threshold) {
            skill.level += 1;
            skill.progress = 0;
        }

        emit SkillUpdated(user, skillId, skill.progress, skill.level);
    }

    // 获得用户技能情况
    function getSkill(address user, uint256 skillId) public view returns (SkillInfo memory) {
        return userSkills[user][skillId];
    }
}