// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ISkill {

    struct SkillInfo {
        uint256 level;      // 当前技能的等级
        uint256 progress;   // 当前技能的进度值
    }

    /**
     * 设置技能升级阈值
     * @param skillId       技能ID
     * @param threshold     提升阈值
     */
    function setUpgradeThreshold(uint256 skillId, uint256 threshold) external;

    /**
     * 更新技能
     * @param user          用户EOA地址
     * @param skillId       技能ID
     * @param progressIncr  提升经验值的数额
     */
    function updateSkill(address user, uint256 skillId, uint256 progressIncr) external;

    /**
     * 获得技能信息
     * @param user          用户EOA地址
     * @param skillId       技能ID
     * @return SkillInfo    技能信息
     */
    function getSkill(address user, uint256 skillId) external view returns (SkillInfo memory);
}
