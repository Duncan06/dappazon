// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {
    address public owner;

    struct Item {
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    struct Order {
        uint256 time;
        Item item;
    }

    mapping(uint256 => Item) public items;
    mapping(address => uint256) public orderCount;
    mapping(address => mapping(uint256 => Order)) public orders;

    event Buy(address buyer, uint256 orderId, uint256 itemId);
    event List(string name, uint256 cost, uint256 quanitity);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

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
        ) public onlyOwner {
            // Create Item struct
            Item memory item = Item(
                _id, 
                _name, 
                _category, 
                _image, 
                _cost, 
                _rating, 
                _stock
            );

            // Save Item Struct to blockchain
            items[_id] = item;

            // Emit on event 
            emit List(_name, _cost, _stock);
    }

    // Buy products
    function buy(uint256 _id) public payable {
        // Fetch Item
        Item memory item = items[_id];

        // Require enough ether to buy item
        require(msg.value >= item.cost);

        // Require item is in stock
        require(item.stock > 0);

        // Recieve Crypto
        Order memory order = Order(block.timestamp, item);

        // Add order for user
        orderCount[msg.sender]++; // <-- Order ID
        orders[msg.sender][orderCount[msg.sender]] = order;

        // Substract stock
        items[_id].stock = item.stock - 1;

        // Emit event
        emit Buy(msg.sender, orderCount[msg.sender], item.id);
    }

    // Withdraw funds
    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }

}
