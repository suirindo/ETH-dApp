// SPDX-Licence-Identifier: UNLICENSED
pragma solidity ^0.8.4;

// OpenZeppelinのコントラクトをインポートする
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// utils ライブラリをimportして文字列の処理を行う
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

    // SVGコードの作成
    // 変更されるのは、表示される単語だけ
    // すべてのNFTにSVGコードを適用するために、baseSvg変数を作成する
    string baseSvg = "<svg xmlns = 'http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox = '0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style> <rect wiidth = '100%' height = '100%' fill = 'black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // ３つの配列 string[]に、それぞれランダムな単語を設定してみる
    string[] firstWords = ["Ghost","Stand","Inner","Kenji","Shosa","Heart"];
    string[] secondWords = ["AI","Memory","Alone","Universe ","Kawai ","Bato"];
    string[] thirdWords = ["Tachikoma","Boma","Complex ","Kacho","Origa","Togusa"];

    // NFT トークンの名前とそのシンボルを渡す
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract.");
    }

    // シードを生成する関数を作成する
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input))); 
    }

    // 各配列からランダムに単語を選ぶ関数を3つ作成する
    // pickRandomFirstWord関数は、最初の単語を選ぶ
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // pickRandomFirstWord 関数のシードとなるrandを作成する
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));

        // seed rand をターミナルに出力する
        console.log("rand seed: ", rand);

        // firstWords配列の長さを基準に、rand 番目の単語を選ぶ
        rand = rand % firstWords.length;

        // firstWords配列から何番目の単語が選ばれるかターミナルに出力する
        console.log("rand first word: ", rand);
        return firstWords[rand];
    }

    // 2番目に表示される単語
    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    // 3番目に表示される単語
    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }


    //ユーザーがNFTを取得するために実行する関数
    function makeAnEpicNFT() public {
        // 現在のtokenIdを取得。tokenIdは0から始まる
        uint256 newItemId = _tokenIds.current();

        // 3つの配列からそれぞれ1つの単語をランダムに取り出す
        string memory first  = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third  = pickRandomThirdWord(newItemId);

        //3つの単語を連結して、<text>タグと<svg>タグで閉じる
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

        // NFTに出力されるテキストをターミナルに出力する
        console.log("\n------------------");
        console.log(finalSvg);
        console.log("------------------\n");


        //msg.sender を使ってNFTを送信者にMintする
        _safeMint(msg.sender, newItemId);

        // NFTデータを設定する
        _setTokenURI(
            newItemId,
             "We will set tokenURI later."
            );

        // NFTがいつ誰に作成されたかを確認する
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // 次のNFTがMintされるときのカウンターをインクリメントする
        _tokenIds.increment();
    }
}
