// deploy : npx hardhat ignition deploy ignition/modules/MyToken.ts
// npx hardhat ignition deploy ignition/modules/MyToken.ts --network localhost

// contract 빌드해서 네트워크에 전송할 수 있도록 도와주는 모듈
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("MyTokenDeploy", (m) => {
  const myTokenC = m.contract("MyToken", ["MyToken", "MT", 18]);
  return { myTokenC };
});
