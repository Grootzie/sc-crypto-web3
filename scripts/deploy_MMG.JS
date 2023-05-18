// scripts/deploy.js
async function main () {
    // We get the contract to deploy
    const MMG = await ethers.getContractFactory('MetaMindGames');
    console.log('Deploying Box...');
    const mmg = await MMG.deploy(["0xeAa414B7FCE5C9998Baa6c61b9998E7332A257b5","0xEE666a3aB51188C9eB42EE3f4E4746723a3d0D66"],[90,10]);
    await mmg.deployed();
    console.log('Box deployed to:', mmg.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });