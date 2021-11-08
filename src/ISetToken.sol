// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface ISetToken {
    function getDefaultPositionRealUnit(address _component) external view returns(int256);
}