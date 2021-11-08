// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { IChainlinkAggregatorV3 } from "./IChainlinkAggregatorV3.sol";
import { ISetToken } from "./ISetToken.sol";

import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";


contract BedOracle {
    using SafeCast for int256;
    
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
        uint256 wbtcUnits = bed.getDefaultPositionRealUnit(wbtc).toUint256();
        uint256 wethUnits = bed.getDefaultPositionRealUnit(weth).toUint256();
        uint256 dpiUnits = bed.getDefaultPositionRealUnit(dpi).toUint256();

        uint256 wbtcPrice = wbtcFeed.latestAnswer().toUint256();
        uint256 dpiPrice = dpiFeed.latestAnswer().toUint256();

        return _getValue(wbtcUnits, wbtcPrice, 8) + _getValue(dpiUnits, dpiPrice, 18) + wethUnits;
    }

    function _getValue(uint256 _units, uint256 _price, uint8 _decimals) internal pure returns (uint256) {
        uint256 normalizedUnits = _units * 10 ** (18 - _decimals);
        return _preciseMul(normalizedUnits, _price);
    }

    function _preciseMul(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return (_a * _b) / 1 ether;
    }
}
