// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenSale {
    uint256 public totalSupply; // Total supply of tokens
    uint256 public tokenPrice; // Price of each token in wei
    uint256 public saleDuration; // Duration of the sale
    uint256 public start; // Start time of the sale
    bool public active; // Boolean to check if the sale is active

    mapping(address => uint256) public tokenPurchased; // Mapping to store the tokens purchased by each buyer
    mapping(address => uint256) public time; // Mapping to store the time of last sale of each buyer
    mapping(address => uint256) public saleAmount; // Mapping to store the amount of tokens sold by each buyer

    // Constructor to initialize the contract
    constructor(uint256 _totalSupply, uint256 _tokenPrice, uint256 _saleDuration) {
        totalSupply = _totalSupply;
        tokenPrice = _tokenPrice; // Assume price is already in wei
        saleDuration = _saleDuration;
        start = block.timestamp; // Set the start time of the sale
        active = true; // Set the sale to active
    }

    // Function to check the total supply of tokens
    function checkTokenPrice() public view returns (uint256) {
        return tokenPrice;
    }

    // Function to check the total tokens purchased by a buyer
    function checkTokenBalance(address buyer) public view returns (uint256) {
        return tokenPurchased[buyer];
    }

    // Function to check the remaining time of the sale
    function saleTimeLeft() public view returns (uint256) {
        require(block.timestamp <= start + saleDuration, "Sale is over"); // Check if the sale is over
        return (start + saleDuration) - block.timestamp; // Return the remaining time of the sale
    }

    // Function to purchase tokens
    function purchaseToken() public payable { // payable function to accept ether
        require(active, "Sale is not active"); // Check if the sale is active
        require(block.timestamp <= start + saleDuration, "Sale is over"); // Check if the sale is over
        require(tokenPurchased[msg.sender] == 0, "You can only buy once"); // Check if the buyer has already purchased tokens
        require(msg.value >= tokenPrice, "Insufficient balance"); // Check if the buyer has sent enough ether
        uint256 tokensToBuy = msg.value / tokenPrice; // Calculate the number of tokens to buy
        require(totalSupply >= tokensToBuy, "Not enough tokens available"); // Check if enough tokens are available

        tokenPurchased[msg.sender] = tokensToBuy; // Update the tokens purchased by the buyer
        saleAmount[msg.sender] = (tokenPurchased[msg.sender] * 20) / 100; // 20% of the tokens can be sold back
        totalSupply -= tokensToBuy; // Update the total supply of tokens

        if (totalSupply == 0 || block.timestamp > start + saleDuration) { // Check if the sale is over or total supply is 0
            active = false; // Set the sale to inactive
        }
    }

    // Function to sell tokens back
    function sellTokenBack(uint256 amount) public { 
        require(amount <= tokenPurchased[msg.sender] * 20 / 100, "You cannot sell more that 20% at once" ); // Check if the amount is less than 20% of the tokens purchased
        require(time[msg.sender] + 1 weeks <= block.timestamp, "you can sell only after 1 week of your previous transaction" ); 
        
        if(amount <= saleAmount[msg.sender]){
            uint priceOfTokenSold = amount * tokenPrice;
            
            tokenPurchased[msg.sender] -= amount;
            totalSupply += amount;
            (bool ok, ) = payable(msg.sender).call{value: priceOfTokenSold}("");
            require(ok);
            saleAmount[msg.sender] -= amount;
        } else {
            revert();
        }
        
        if(saleAmount[msg.sender] == 0 ){ // Check if the buyer has sold all the tokens
            time[msg.sender] = block.timestamp; // Update the time of last sale
        }
    }
}
