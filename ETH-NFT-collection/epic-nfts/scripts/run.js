// run.js はローカル環境でコードのテストを行うためのスクリプト

const { header } = require("express/lib/request")

// async/ await awaitが先頭についている処理が終わるまで、main関数の他の処理は行われない
const main = async () => {
    // コントラクトがコンパイルする
    // コントラクトを扱うために必要なファイルが、'artifacts'ディレクトリの直下に生成される
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    // hardhatがローカルのEthereumネットワークを作成する
    const nftContract = await nftContractFactory.deploy();
    // コントラクトがmintされ、ローカルのブロックチェーンにデプロイされるまで待つ。
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    // makeAnEpicNFT関数を呼び出す。NFTがMintされる
    let txn = await nftContract.makeAnEpicNFT();
    // Miningが仮想マイナーにより、承認されるのを待つ
    await txn.wait();
    // makeAnEpicNFT関数をもう一度呼び出す。NFTがまたMintされる
    txn = await nftContract.makeAnEpicNFT();
    // Mintingが仮想マイナーにより、承認されるのを待つ
    await txn.wait();
};

// エラー処理を行う
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