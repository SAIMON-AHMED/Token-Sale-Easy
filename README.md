# Token-Sale-Easy

You have been assigned the task of developing a token sale smart contract for a project.
A token sale contract is a program that manages the sale of digital tokens. These tokens could represent anything from ownership rights to access on a decentralized platform.

This contract outlines the rules of the token sale, such as:
The total number of tokens available for purchase.
The price of each token in cryptocurrency.
The duration of the sale period.
How the purchased tokens will be distributed among buyers.

The smart contract will facilitate the sale of tokens to the public and include the following functionalities:
 

Input:
constructor(uint totalSupply, uint tokenPrice, uint saleDuration) : The constructor function should initialize the contract by setting the total supply of tokens, the token price in wei, and the duration of the token sale.

purchaseToken() : This function should allow an address to purchase tokens during the token sale. The address can only purchase tokens once. The function should check if the token sale is active, the amount sent is sufficient to purchase at least one token, and there are enough tokens available for purchase.

sellTokenBack(uint amount) : This function should allow a buyer to sell back a specified amount of tokens they have purchased. The user should only be able to sell a maximum of 20% of their bought tokens in a week. The corresponding amount in wei should be transferred back to the buyer's address.

 

Output:
checkTokenPrice() returns (uint): This function should return the current price of the tokens in wei.

checkTokenBalance(address buyer) returns (uint):This function should return the token balance of a specific buyer address.

saleTimeLeft(address buyer) returns (uint):This function should return the remaining time for the token sale in seconds. If the sale has ended then the transaction should fail.
