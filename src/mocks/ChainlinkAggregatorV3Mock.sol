
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;


contract ChainlinkAggregatorV3Mock {

    int256 private latestPrice;

    constructor() {
        latestPrice = 0;
    }

    function setPrice(int256 _price) external {
        latestPrice = _price;
    }

    function latestAnswer() external view returns (int256) {
        return latestPrice;
    }
}