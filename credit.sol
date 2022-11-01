// SPDX-License-Identifier: GPL-3.0
//Vishal Gondke 2019140025 BE IT
pragma solidity ^0.8.4;

contract LotteryVishal {
    uint creditLimit = 10000;
    constructor(){
        creditLimit=10000;
    }
    function getCreditLimit()public view returns (uint){
        return creditLimit;
    }

    function expenditure(uint travelCost,uint stayCost, uint foodCost)public{
        uint totalExpenditure= travelCost+foodCost+stayCost;
        require(creditLimit-totalExpenditure>=0,"Total cost exceeded the credit limit");
        creditLimit=creditLimit-totalExpenditure;
    }

}