// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {ISkill} from "./interface/ISkill.sol";

contract Skill is ISkill {

    // 用户技能信息
    mapping (address => mapping (uint256 => SkillInfo)) internal userSkills;
    // 技能升级阈值
    mapping (uint256 => uint256) public skillUpgradeThresholds;

    // 自定义错误
    error ThresholdNotSet(uint256 skillId);
    error InvalidThreshold(uint256 skillId, uint256 threshold);

    // 事件
    event SkillUpdated(address indexed user, uint256 indexed skillId, uint256 newProgress, uint256 newLevel);
    event SkillUpgradeThresholdSet(uint256 indexed skillId, uint256 threshold);

    // 设置技能阈值
    function setUpgradeThreshold(uint256 skillId, uint256 threshold) external override {
        if (threshold == 0) {
            revert InvalidThreshold(skillId, threshold);
        }

        skillUpgradeThresholds[skillId] = threshold;
        emit SkillUpgradeThresholdSet(skillId, threshold);
    }

    // 更新技能进度
    function updateSkill(address user, uint256 skillId, uint256 processIncr) external override {
        uint256 threshold = skillUpgradeThresholds[skillId];

        // 检查是否设置了技能阈值
        if (threshold <= 0) {
            revert ThresholdNotSet(skillId);
        }

        SkillInfo storage skill = userSkills[user][skillId];
        skill.progress += processIncr;

        if (skill.progress >= threshold) {
            uint256 levelsGained = skill.progress / threshold;
            skill.level += levelsGained;
            skill.progress %= threshold;
        }

        emit SkillUpdated(user, skillId, skill.progress, skill.level);
    }

    // 获得用户技能情况
    function getSkill(address user, uint256 skillId) external view returns (SkillInfo memory) {
        SkillInfo memory skill = userSkills[user][skillId];
        return skill;
    }
}
