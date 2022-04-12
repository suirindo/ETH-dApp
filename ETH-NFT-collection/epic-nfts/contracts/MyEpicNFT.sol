// SPDX-Licence-Identifier: UNLICENSED
pragma solidity ^0.8.4;

// OpenZeppelinのコントラクトをインポートする
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// contractは1つのconstrucotしか持つことができない
// constructorはスマコンの作成時に一度だけ実行され、contractの状態を初期化するために使用される
// constructorはコントラクトがデプロイされた時に初めて実行される
// constructorが実行された後、コードがブロックチェーンにデプロイされる

// importしたOpenzeppelinのコントラクトを継承
// 継承したコントラクトのメソッドにアクセスできるようになる
contract MyEpicNFT is ERC721URIStorage {
    // OpenZeppelin が tokenIds を簡単に追跡するために提供するライブラリを呼び出している
    using Counters for Counters.Counter;

    // _tokenIdsを初期化(_tokenIds = 0)
    Counters.Counter private _tokenIds;

    // NFT トークンの名前とそのシンボルを渡す
    constructor() ERC721 ("TanyaNFT", "TANYA") {
        console.log("This is my NFT contract.");
    }

    //ユーザーがNFTを取得するために実行する関数
    function makeAnEpicNFT() public {
        // 現在のtokenIdを取得。tokenIdは0から始まる
        uint256 newItemId = _tokenIds.current();

        //msg.sender を使ってNFTを送信者にMintする
        _safeMint(msg.sender, newItemId);

        // NFTデータを設定する
        _setTokenURI(newItemId,
             "https://jsonkeeper.com/b/IWRR");

        // NFTがいつ誰に作成されたかを確認する
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // 次のNFTがMintされるときのカウンターをインクリメントする
        _tokenIds.increment();
    }
}
