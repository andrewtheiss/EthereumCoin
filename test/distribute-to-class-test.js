const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token Contract", function () {
    
  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    WVC = await ethers.getContractFactory("WVC");
    [owner, addr1, addr2, addr3] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    hwc = await WVC.deploy();
    await hwc.deployed();
    await hwc.initialize();
  });
  
  
});