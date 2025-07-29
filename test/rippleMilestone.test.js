const { expect } = require("chai");
const hre = require("hardhat");
const { ethers } = require("ethers");

describe("RippleMilestone", function () {
  let RippleMilestone, rippleMilestone;
  let owner, buyer, seller;

  beforeEach(async function () {
    [owner, buyer, seller] = await hre.ethers.getSigners();

    const totalValue = ethers.parseEther("3");
    const milestoneValues = [
      ethers.parseEther("1"),
      ethers.parseEther("1"),
      ethers.parseEther("1"),
    ];

    RippleMilestone = await hre.ethers.getContractFactory("RippleMilestone");
    rippleMilestone = await RippleMilestone.deploy(
      owner.address,
      buyer.address,
      totalValue,
      milestoneValues,
      { value: totalValue }
    );

    await rippleMilestone.waitForDeployment();
  });

  it("should deploy successfully", async function () {
    expect(rippleMilestone.target).to.be.properAddress;
  });

  it("should release first milestone", async function () {
    await rippleMilestone.connect(owner).releaseMilestone(0);

    const released = await rippleMilestone.milestoneReleased(0);
    const amount = await rippleMilestone.milestoneRelease(0);

    expect(released).to.be.true;
    expect(amount).to.equal(ethers.parseEther("1"));
  });
});