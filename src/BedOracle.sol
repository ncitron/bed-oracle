// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { IChainlinkAggregatorV3 } from "./IChainlinkAggregatorV3.sol";
import { ISetToken } from "./ISetToken.sol";

contract BedOracle {
    
    ISetToken public bed;

    // component addresses
    address public wbtc;
    address public weth;
    address public dpi;

    // Chainlink feeds priced in ETH
    IChainlinkAggregatorV3 public wbtcFeed;
    IChainlinkAggregatorV3 public dpiFeed;

    constructor(
        ISetToken _bed,
        address _wbtc,
        address _weth,
        address _dpi,
        IChainlinkAggregatorV3 _wbtcFeed,
        IChainlinkAggregatorV3 _dpiFeed
    ) {
        bed = _bed;

        wbtc = _wbtc;
        weth = _weth;
        dpi = _dpi;
        
        wbtcFeed = _wbtcFeed;
        dpiFeed = _dpiFeed;
    }

    function getPrice() external view returns (uint256) {

    }
}
