// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { IChainlinkAggregatorV3 } from "./interfaces/IChainlinkAggregatorV3.sol";
import { ISetToken } from "./interfaces/ISetToken.sol";

import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";


/// @title BedOracle
/// @author ncitron
/// @notice Price oracle for the BED token
/// @dev This setup should not be replicated for other set tokens. This works for BED since
/// it is guaranteed that BED will never contain any other tokens except for wBTC, WETH,
/// and DPI (even during rebalancing).
contract BedOracle {
    using SafeCast for int256;
    
    /// @notice BED token
    ISetToken public bed;

    /// @notice wBTC token address
    address public wbtc;

    /// @notice WETH token address
    address public weth;

    /// @notice DPI token address
    address public dpi;

    /// @notice BTC Chainlink price feed
    /// @dev Must be priced in ETH and return 18 decimals
    IChainlinkAggregatorV3 public btcFeed;


    /// @notice DPI Chainlink price feed
    /// @dev Must be priced in ETH and return 18 decimals
    IChainlinkAggregatorV3 public dpiFeed;

    /// @notice Creates a new BedOracle
    /// @param _bed  BED token
    /// @param _wbtc wBTC token
    /// @param _weth WETH token
    /// @param _dpi DPI token
    /// @param _btcFeed Chainlink feed for BTC/ETH
    /// @param _dpiFeed Chainlink feed for DPI/ETH
    constructor(
        ISetToken _bed,
        address _wbtc,
        address _weth,
        address _dpi,
        IChainlinkAggregatorV3 _btcFeed,
        IChainlinkAggregatorV3 _dpiFeed
    ) {
        bed = _bed;

        wbtc = _wbtc;
        weth = _weth;
        dpi = _dpi;
        
        btcFeed = _btcFeed;
        dpiFeed = _dpiFeed;
    }

    /// @notice Gets the price of BED in ETH
    /// @return BED price
    function getPrice() external view returns (uint256) {
        uint256 wbtcUnits = bed.getDefaultPositionRealUnit(wbtc).toUint256();
        uint256 wethUnits = bed.getDefaultPositionRealUnit(weth).toUint256();
        uint256 dpiUnits = bed.getDefaultPositionRealUnit(dpi).toUint256();

        uint256 wbtcPrice = btcFeed.latestAnswer().toUint256();
        uint256 dpiPrice = dpiFeed.latestAnswer().toUint256();

        return _getValue(wbtcUnits, wbtcPrice, 8) + _getValue(dpiUnits, dpiPrice, 18) + wethUnits;
    }

    /// @dev Calculates the value of a set component in ETH
    /// @param _units Amount of the component per set
    /// @param _price Price of the component in ETH
    /// @param _decimals Decimals of the component token
    function _getValue(uint256 _units, uint256 _price, uint8 _decimals) internal pure returns (uint256) {
        uint256 normalizedUnits = _units * 10 ** (18 - _decimals);
        return _preciseMul(normalizedUnits, _price);
    }

    /// @dev multiplies two 18 decimal fixed point numbers
    function _preciseMul(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return (_a * _b) / 1 ether;
    }
}
