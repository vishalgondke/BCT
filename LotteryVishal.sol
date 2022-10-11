// SPDX-License-Identifier: GPL-3.0
//Vishal Gondke 2019140025 BE IT
pragma solidity ^0.8.4;

contract LotteryVishal {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager(){
        require(msg.sender==manager,"Only Manager can access this function");
        _;
    }

    receive() external payable {
        require(msg.value >= 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public onlyManager view returns(uint) {
        return address(this).balance;
    }

    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() onlyManager public returns(address) {
        require(participants.length >= 3);
        address payable winner;
        uint r = random();
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0); //reset the participants array after lottery winner is announced
        return winner;
    }
}
