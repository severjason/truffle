// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Owned {
    address public owner;
    address private ownerCandidat;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        // function body
        _;
        
        // if (msg.sender == owner) {
        //     _;
        // } else revert("exception text");
    }

    constructor() {
        owner = msg.sender;
    }

    function isOwnerCandidat() view public returns(bool) {
        return msg.sender == ownerCandidat;
    }

    function setNewOwnerCandidat(address newOwner) public onlyOwner {
        ownerCandidat = newOwner;
    }

    function takeOwnership() public {
        require(msg.sender == ownerCandidat, "You are a not the candidat");
        owner = msg.sender;
    }
}