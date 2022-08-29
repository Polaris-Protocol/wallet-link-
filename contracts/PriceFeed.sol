// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {

    AggregatorV3Interface internal priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
    }

    event WalletLink(address walletAddress, string keyHash);

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (uint) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return uint(price);
    }

    function linkWallet(string calldata keyHash) public payable returns(uint){
        require(getLatestPrice() * msg.value/10**18 > 5000000, "Must pay minimum price" ); // 5 cents
        emit WalletLink(msg.sender, keyHash);
        return getLatestPrice() * msg.value;
    }
}
