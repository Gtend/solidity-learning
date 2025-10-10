// test 이름 == contract file

import hre from "hardhat";
import { expect } from "chai";
import { MyToken } from "../typechain-types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { parseUnits } from "ethers";

const mintingAmount = 100n;
const decimals = 18n;

describe("My Token", () => {
  let myTokenC: MyToken;
  let signers: HardhatEthersSigner[];

  // before : it 실행 전 단 한번만 실행 -> dependency 있는 it 있을 때
  // beforeEach : it 실행 전 매번 실행 -> it 들이 서로 독립적일 때 == Unit Test
  beforeEach("should deploy", async () => {
    signers = await hre.ethers.getSigners();

    // default signer 0 : (배포 = Transaction) -> gas(transaction 수수료) 비용 발생
    myTokenC = await hre.ethers.deployContract("MyToken", [
      "MyToken",
      "MT",
      decimals,
      100,
    ]);

    // console.log(await myTokenC.name());
    // expect(await myTokenC.name()).equal("MyToken");
    // expect(await myTokenC.symbol()).equal("MT");
    // expect(await myTokenC.decimals()).equal(18);
  });

  describe("Basic state value check", () => {
    it("should return name", async () => {
      expect(await myTokenC.name()).equal("MyToken");
    });
    it("should return symbol", async () => {
      expect(await myTokenC.symbol()).equal("MT");
    });
    it("should return decimals", async () => {
      expect(await myTokenC.decimals()).equal(18);
    });
    it("should return 100 MT totalSupply", async () => {
      expect(await myTokenC.totalSupply()).equal(
        mintingAmount * 10n ** decimals
      );
    });
  });

  // 1 MT = 1*10^18
  describe("Mint", () => {
    it("should return 1 MT balance for signer 0", async () => {
      expect(await myTokenC.balanceOf(signers[0].address)).equal(
        mintingAmount * 10n ** decimals
      );
    });
  });
  describe("Transfer", () => {
    it("should have 0.5 MT", async () => {
      const signer0 = signers[0];
      const signer1 = signers[1];

      // 이벤트 발생 여부 확인, expect 체크할때는 await expect()
      await expect(
        myTokenC.transfer(parseUnits("0.5", decimals), signer1.address)
      )
        .to.emit(myTokenC, "Transfer")
        .withArgs(
          signer0.address,
          signer1.address,
          parseUnits("0.5", decimals)
        );

      //   const tx = await myTokenC.transfer(
      //     parseUnits("0.5", decimals),
      //     signer1.address
      //   );
      //   const receipt = await tx.wait();
      //   console.log(receipt?.logs);
      // console.log(await myTokenC.balanceOf(signer1.address));

      expect(await myTokenC.balanceOf(signer1.address)).equal(
        parseUnits("0.5", decimals)
      );

      //   const filter = myTokenC.filters.Transfer(signer0.address);
      //   const logs = await myTokenC.queryFilter(filter, 0, "latest");
      //   console.log(logs.length);

      //   console.log(logs[0].args.from);
      //   console.log(logs[0].args.to);
      //   console.log(logs[0].args.value);
    });
    it("should be reverted with insufficient balance error", async () => {
      const signer1 = signers[1];
      // exception test 는 await expect(실행문)
      await expect(
        myTokenC.transfer(
          parseUnits((mintingAmount + 1n).toString(), decimals),
          signer1.address
        )
      ).to.be.revertedWith("insufficient balance");
    });
  });
  describe("TransferFrom", () => {
    it("should emit Approval event", async () => {
      const signer1 = signers[1];
      await expect(
        myTokenC.approve(signer1.address, parseUnits("10", decimals))
      )
        .to.emit(myTokenC, "Approval")
        .withArgs(signer1.address, parseUnits("10", decimals));
    });
    it("should be reverted with insufficient allowance error", async () => {
      const signer0 = signers[0];
      const signer1 = signers[1];
      await expect(
        myTokenC
          .connect(signer1)
          .transferFrom(
            signer0.address,
            signer1.address,
            parseUnits("1", decimals)
          )
      ).to.be.revertedWith("insufficient allowance");
    });
  });
});
