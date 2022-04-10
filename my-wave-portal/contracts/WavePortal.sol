// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    // 乱数生成のための基盤となるシード（タネ）を作成
    uint256 private seed;

    // NewWaveイベントの作成
    event NewWave(address indexed from, uint256 timestamp, string message);
    // waveという構造体を作成。
    // 構造体の中身は、カスタマイズすることができる

    struct Wave {
        address waver; //waveを送ったユーザーのアドレス
        string message; //ユーザーが送ったメッセージ
        uint256 timestamp; //ユーザーがwaveを送った瞬間のタイムスタンプ
    }

    // 構造体の配列を格納するための変数wavesを宣言
    // これで、ユーザーが送ってきたすべてのwaveを保持することができる
    Wave[] waves;
    // address => uint mapping は、アドレスと数値を関連づける
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("We have been constructed!");
        // constructorの中に、ユーザーのために生成された乱数（初期シード）を設定、格納
        seed = (block.timestamp + block.difficulty) % 100; // % 100 により、数値を0~100の範囲に設定している。
    }

    // _messageという文字列を要求するようにwave関数を更新
    // _messageは、ユーザーがフロントエンドから送信するメッセージ

    function wave(string memory _message) public {
        // 現在ユーザーがwaveを送信している時刻と、前回waveを送信した時刻が15分以上離れていることを確認
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30seconds"
        );
        // ユーザーの現在のタイムスタンプを更新する
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);

        //waveとメッセージを配列に格納
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // ユーザーのために乱数を生成
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        // ユーザーがETHを獲得する確率を50%に設定
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            // waveを送ってくれたユーザーに0.0001ETHを送る
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}(" ");
            require(success, "Failed to withdraw money from contract.");
        } else {
            console.log("%s did not win.", msg.sender);
        }

        // コントラクト側でemitされたイベントに関する通知をフロントエンドで取得できるようにする
        emit NewWave(msg.sender, block.timestamp, _message);
    }
    // 構造体配列のwavesを返してくれるgetAllWavesという関数を追加
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }
}