// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {
    string public name = "Dappazon";
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // List products
    function list(
        uint256 _id, 
        string memory _name, 
        string memory _category,
        string memory _image, 
        uint256 _cost,
        uint256 _rating,
        uint256 _stock
        ) public {

    }

    // Buy products

    // Withdraw funds
}
