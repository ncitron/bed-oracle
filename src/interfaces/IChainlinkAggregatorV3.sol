// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IChainlinkAggregatorV3 {
    function latestAnswer() external view returns (int256);
}