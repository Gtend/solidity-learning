import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("MyTokenDeploy", (m) => {
  // MyToken(name, symbol, decimals, initialSupply)
  const myTokenC = m.contract("MyToken", ["MyToken", "MT", 18, 100]);

  // Manager 5명을 모두 deployer 계정으로 지정
  const deployer = m.getAccount(0);
  const managers = [deployer, deployer, deployer, deployer, deployer];

  // TinyBank(IMyToken _stakingToken, address[5] memory _managers)
  const tinyBankC = m.contract("TinyBank", [myTokenC, managers]);

  // MyToken.setManager(address manager)
  m.call(myTokenC, "setManager", [tinyBankC]);

  return { myTokenC, tinyBankC };
});
