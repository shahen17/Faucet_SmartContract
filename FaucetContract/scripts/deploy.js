async function main() {
  const Faucet = await hre.ethers.deployContract("Faucet");
  await Faucet.waitForDeployment();

  console.log(`Faucet deployed to : ${Faucet.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});