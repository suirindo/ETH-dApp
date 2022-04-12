// テストネットにコントラクトをデプロイするためのスクリプト

const main = async () => {
    // コントラクトがコンパイルする
    // コントラクトを扱うために必要なファイルが、 artifactsディレクトリの直下に生成される
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    // HardhatがローカルのEthereumネットワークを作成する
    const nftContract = await nftContractFactory.deploy();
    // コントラクトがMintされ、ローカルのブロックチェーンにデプロイされるまで待つ
    await nftContract.deployed();
    console.group("Contract deployed to:", nftContract.address);
    // makeAnEpicNFT 関数を呼び出す。NFTがMintされる
    let txn = await nftContract.makeAnEpicNFT();
    // Miningが仮想マイナーにより承認されるのを待つ
    await txn.wait();
    console.log("Minted NFT #1");
    // makeAnEpicNFT 関数をもう一度呼び出す。NFTがまたMintされる
    txn = await nftContract.makeAnEpicNFT();
    // Mintingが仮想マイナーにより承認されるのを待つ
    await txn.wait();
    console.log("Minted NFT #2");
};

// エラー処理
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