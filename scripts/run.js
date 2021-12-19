const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.006'),
    });
    await waveContract.deployed();
    console.log("Contract address:", waveContract.address);

    // Get Contract balance
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log('Contract balance:', hre.ethers.utils.formatEther(contractBalance));

    // send wave
    const waveTxn = await waveContract.wave('This is wave #1');
    await waveTxn.wait();
    
    const waveTxn2 = await waveContract.wave('This is wave #2');
    await waveTxn2.wait();

    //Get the balance to se what happened!
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log('Contract balance:', hre.ethers.utils.formatEther(contractBalance));

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    let waveCount;
    let waveAddressCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());
    waveAddressCount = await waveContract.getTotalAddresses();
    console.log(waveAddressCount.toNumber());
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch(error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();