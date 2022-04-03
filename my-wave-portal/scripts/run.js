// ローカル環境でスマコンのテストを行うためのプログラム

const main = async () => {
    // WavePortalコントラクトがコンパイルされ、コンパイルを扱うために必要なファイルがartifatcsディレクトリ直下に生成される。
    const [owner, randomPerson1, randomPerson2] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy();
    const wavePortal = await waveContract.deployed();

    console.log("Contract deployed to: ", wavePortal.address);
    console.log("Contract deployed by: ", owner.address);

    let waveCount;
    waveCount = await waveContract.getTotalWaves();

    let waveTxn = await waveContract.wave();
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();

    waveTxn = await waveContract.connect(randomPerson1, randomPerson2).wave();
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();
