// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract FTokenMock {

    address public underlying;

    constructor(address _underlying) {
        underlying = _underlying;
    }
}