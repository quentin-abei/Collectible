// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Collectible {
    event Deployed(address addr);
    event Transfer(address addr1, address addr2);
    event ForSale(uint _price, uint _timestamp);
    event Purchase(uint _amount, address _buyer);
    error Notanowner();
    error Notforsale();
    error Notenoughmoney();
    address owner;
    uint price;
    constructor() {
        owner = msg.sender;
        emit Deployed(msg.sender);
        
    }
    function markPrice(uint _askingPrice) external {
        if (msg.sender != owner){
            revert Notanowner();
        }
        price = _askingPrice;
        emit ForSale(price, block.timestamp);
    }

    function purchase() external payable {
        if (price == 0){
            revert Notforsale();
        }
        if(msg.value < price) {
            revert Notenoughmoney();
        }
        price = 0;
        (bool success, ) = owner.call{value: msg.value}("");
        require(success, "Failed to send ETH");
        owner = msg.sender;
        emit Purchase(msg.value, msg.sender);
    }

    function transfer(address _recipient) external {
           if(msg.sender != owner){
               revert Notanowner();
           }
           owner = _recipient;
           emit Transfer(msg.sender, _recipient);
    }
}