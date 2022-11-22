//SPDX-License-Identifier: MIT
//Vishal Gondke
//BE IT 2019140025
pragma solidity ^0.8.3;

contract Crowdfunding{
    mapping(address=>uint) public contributors;
    address public manager;
    uint minimumDonation;
    uint target;
    uint raisedAmount;
    uint deadline;
    uint numberOfContributors;

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint numberOfVoters;
        mapping(address=>bool) voters;
    }
    mapping(uint=>Request) public requests;
    uint public numRequests;

    constructor(uint _target,uint _deadline){
        target=_target;
        deadline=block.timestamp+_deadline;
        minimumDonation=100 wei;
        manager=msg.sender;
    }

    function sendEth() public payable{
        require(manager!=msg.sender,"Manager cannot contribute");
        require(block.timestamp<deadline,"The deadline has passed and you can no longer donate!");
        require(msg.value>=minimumDonation,"The value did not meet the minimum amount of donation required!");
        if(contributors[msg.sender]==0){
            numberOfContributors++;
        }
        contributors[msg.sender]=msg.value;
        raisedAmount+=msg.value;
    }

    function getContractBalance() public view returns (uint){
        return address(this).balance;
    }

    function refund() public{
        require(raisedAmount<target && block.timestamp>deadline,"You are not eligible for refund");
        require(contributors[msg.sender]>0);
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;
    }

    modifier onlyManager(){
        require(msg.sender==manager,"Only manager can call this function!");
        _;
    }

    function createRequest(string memory _description,address payable _recipient,uint _value) public onlyManager{
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.numberOfVoters=0;
    }

    function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender]>0,"You need to be a contributor in order to vote!");
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"You have already voted!");
        thisRequest.voters[msg.sender]=true;
        thisRequest.numberOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyManager {
        require(raisedAmount>=target);
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.completed==false,"This request has been completed");
        require(thisRequest.numberOfVoters>numberOfContributors/2,"Majority does not support");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;
    }
}