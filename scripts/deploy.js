async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // XanderToken contract address (replace this with the actual deployed address)
    const tokenAddress = "0x0893326bEED7E5c902D166768375797ddA25093a"; 

    const AssetManager = await ethers.getContractFactory("AssetManager");
    const assetManager = await AssetManager.deploy(tokenAddress); // Pass the token address

    console.log("AssetManager contract deployed to:", assetManager.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
