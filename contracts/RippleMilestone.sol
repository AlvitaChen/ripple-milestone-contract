// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract RippleMilestone {
    address public exporter;
    address public importer;
    address public platform;

    uint256 public totalValue;
    uint256 public milestoneCount;
    uint256 public currentMilestone;

    mapping(uint256 => uint256) public milestoneRelease; // milestoneIndex => release amount
    mapping(uint256 => bool) public milestoneReleased;

    event MilestoneFunded(uint256 milestoneIndex, uint256 amount);
    event MilestoneReleased(uint256 milestoneIndex, uint256 amount);
    event ContractInitialized();

    constructor(
        address _exporter,
        address _importer,
        uint256 _totalValue,
        uint256[] memory _milestoneValues
    ) payable {
        require(_milestoneValues.length > 0, "Must define milestones");
        exporter = _exporter;
        importer = _importer;
        platform = msg.sender;
        totalValue = _totalValue;
        milestoneCount = _milestoneValues.length;

        uint256 sum = 0;
        for (uint256 i = 0; i < _milestoneValues.length; i++) {
            milestoneRelease[i] = _milestoneValues[i];
            sum += _milestoneValues[i];
        }
        require(sum == _totalValue, "Milestone values must match total");

        emit ContractInitialized();
    }

    function releaseMilestone(uint256 milestoneIndex) public {
        require(msg.sender == platform, "Only platform can trigger release");
        require(!milestoneReleased[milestoneIndex], "Already released");

        milestoneReleased[milestoneIndex] = true;
        uint256 amount = milestoneRelease[milestoneIndex];

        payable(exporter).transfer(amount);
        emit MilestoneReleased(milestoneIndex, amount);
    }

    receive() external payable {}
}
