// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IBedOracle {
    function getPrice() external view returns (uint256);
}
