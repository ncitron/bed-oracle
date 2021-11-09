// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { ISetToken } from "../interfaces/ISetToken.sol";

contract SetTokenMock is ISetToken {

    mapping(address => int256) units;

    constructor(address[] memory _components, int256[] memory _units) {
        for (uint256 i = 0; i < _components.length; i++) {
            units[_components[i]] = _units[i];
        }
    }

    function getDefaultPositionRealUnit(address _component) external view override returns (int256) {
        return units[_component];
    }
}