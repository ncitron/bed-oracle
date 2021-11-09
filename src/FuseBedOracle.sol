// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { IBedOracle } from "./interfaces/IBedOracle.sol";
import { IFToken } from "./interfaces/IFToken.sol";


contract FuseBedOracle {
    
    IBedOracle public bedOracle;
    address public bed;

    constructor(IBedOracle _bedOracle, address _bed) {
        bedOracle = _bedOracle;
        bed = _bed;
    }

    function price(address _underlying) external view returns (uint256) {
        require(_underlying == bed, "oracle not found");
        return bedOracle.getPrice();
    }

    function getUnderlyingPrice(IFToken _fToken) external view returns (uint256) {
        require(_fToken.underlying() == bed, "oracle not found");
        return bedOracle.getPrice();
    }
}