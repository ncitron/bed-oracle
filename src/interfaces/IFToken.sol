// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IFToken {
    function underlying() external view returns (address);
}