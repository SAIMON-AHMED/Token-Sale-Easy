// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenSale {
    uint256 public totalSupply;
    uint256 public tokenPrice;
    uint256 public saleDuration;
    uint256 public start;
    bool public active;

    mapping(address => uint256) public tokenPurchased;
    mapping(address => uint256) public time;
    mapping(address => uint256) public saleAmount;

    constructor(uint256 _totalSupply, uint256 _tokenPrice, uint256 _saleDuration) {
        totalSupply = _totalSupply;
        tokenPrice = _tokenPrice; // Assume price is already in wei
        saleDuration = _saleDuration;
        start = block.timestamp;
        active = true;
    }

    function checkTokenPrice() public view returns (uint256) {
        return tokenPrice;
    }

    function checkTokenBalance(address buyer) public view returns (uint256) {
        return tokenPurchased[buyer];
    }

    function saleTimeLeft() public view returns (uint256) {
        require(block.timestamp <= start + saleDuration, "Sale is over");
        return (start + saleDuration) - block.timestamp;
    }

    function purchaseToken() public payable {
        require(active, "Sale is not active");
        require(block.timestamp <= start + saleDuration, "Sale is over");
        require(tokenPurchased[msg.sender] == 0, "You can only buy once");
        require(msg.value >= tokenPrice, "Insufficient balance");
        uint256 tokensToBuy = msg.value / tokenPrice;
        require(totalSupply >= tokensToBuy, "Not enough tokens available");

        tokenPurchased[msg.sender] = tokensToBuy;
        saleAmount[msg.sender] += (tokenPurchased[msg.sender] * 20) / 100;
        totalSupply -= tokensToBuy;

        if (totalSupply == 0 || block.timestamp > start + saleDuration) {
            active = false;
        }
    }

    function sellTokenBack(uint256 amount) public {
        require(amount <= tokenPurchased[msg.sender] * 20 / 100, "You cannot sell more that 20% at once" );
        require(time[msg.sender] + 1 weeks <= block.timestamp, "you can sell only after 1 week of your previous transaction" );
        
        if(amount <= saleAmount[msg.sender]){
            uint priceOfTokenSold = amount * tokenPrice;
            
            tokenPurchased[msg.sender] -= amount;
            totalSupply += amount;
            (bool ok, ) = payable(msg.sender).call{value: priceOfTokenSold}("");
            require(ok);
            saleAmount[msg.sender] -= amount;
        }
        else{
            revert();
        }
        
        if(saleAmount[msg.sender] == 0 ){
            time[msg.sender] = block.timestamp;
        }
    }
}
