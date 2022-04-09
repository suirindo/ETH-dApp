// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
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
    constructor() payable {
        console.log("We have been constructed!");
    }

    // _messageという文字列を要求するようにwave関数を更新
    // _messageは、ユーザーがフロントエンドから送信するメッセージ

    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);

        //waveとメッセージを配列に格納
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // コントラクト側でemitされたイベントに関する通知をフロントエンドで取得できるようにする
        emit NewWave(msg.sender, block.timestamp, _message);

        // waveを送ってくれたユーザーに0.0001ETHを送る
        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}(" ");
        require(success, "Failed to withdraw money from contract.");
    }

    // 構造体配列のwavesを返してくれるgetAllWavesという関数を追加

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}