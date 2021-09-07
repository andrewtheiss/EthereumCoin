const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token Contract", function () {
    
  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    HWC = await ethers.getContractFactory("HWC");
    [owner, addr1, addr2, addr3] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    hwc = await HWC.deploy();
    await hwc.deployed();
    await hwc.initialize();
  });


  // You can nest describe calls to create subsections.
  describe("Deployment", function () {
    // `it` is another Mocha function. This is the one you use to define your
    // tests. It receives the test name, and a callback function.

    // If the callback function is async, Mocha will `await` it.
    it("Should set the right owner", async function () {
      // Expect receives a value, and wraps it in an Assertion object. These
      // objects have a lot of utility methods to assert values.

      // This test expects the owner variable stored in the contract to be equal
      // to our Signer's owner.
      expect(await hwc.owner()).to.equal(owner.address);
    });

    it("Should assign the initial 10000 tokens to the owner", async function () {
      const ownerBalance = await hwc.balanceOf(owner.address);
      expect(ownerBalance).to.equal(10000);
    });
  });
  
  
  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {
      // Transfer 50 tokens from owner to addr1
      await hwc.transfer(addr1.address, 50);
      const addr1Balance = await hwc.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(50);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await hwc.connect(addr1).transfer(addr2.address, 50);
      const addr2Balance = await hwc.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });


    it("Should fail if sender doesn’t have enough tokens", async function () {
      const initialOwnerBalance = await hwc.balanceOf(owner.address);

      // Try to send 1 token from addr1 (0 tokens) to owner (1000000 tokens).
      // `require` will evaluate false and revert the transaction.
      await expect(
        hwc.connect(addr3).transfer(owner.address, 1)
      ).to.be.revertedWith("ERC20: transfer amount exceeds balance");

      // Owner balance shouldn't have changed.
      expect(await hwc.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });

    it("Should update balances after transfers", async function () {
      const initialOwnerBalance = await hwc.balanceOf(owner.address);

      // Transfer 100 tokens from owner to addr1.
      await hwc.transfer(addr1.address, 100);

      // Transfer another 50 tokens from owner to addr2.
      await hwc.transfer(addr2.address, 50);

      // Check balances.
      const finalOwnerBalance = await hwc.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(initialOwnerBalance - 150);

      const addr1Balance = await hwc.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(100);

      const addr2Balance = await hwc.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });
  });
  
});
