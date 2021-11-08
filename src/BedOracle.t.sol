// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import { BedOracle } from "./BedOracle.sol";
import { ChainlinkAggregatorV3Mock } from "./ChainlinkAggregatorV3Mock.sol";
import { IChainlinkAggregatorV3 } from "./IChainlinkAggregatorV3.sol";
import { SetTokenMock } from "./SetTokenMock.sol";


contract BedOracleTest is DSTest {

    BedOracle oracle;

    SetTokenMock bed;
    
    address wbtc;
    address weth;
    address dpi;

    ChainlinkAggregatorV3Mock btcFeed;
    ChainlinkAggregatorV3Mock dpiFeed;

    function setUp() public {
        wbtc = address(0x1);
        weth = address(0x2);
        dpi = address(0x3);

        address[] memory components = new address[](3);
        components[0] = wbtc;
        components[1] = weth;
        components[2] = dpi;

        int256[] memory units = new int256[](3);
        units[0] = 1 * 10**5;   // 0.001 wBTC
        units[1] = 0.01 ether;
        units[2] = 0.1 ether;

        bed = new SetTokenMock(components, units);

        btcFeed = new ChainlinkAggregatorV3Mock();
        btcFeed.setPrice(13 ether);

        dpiFeed = new ChainlinkAggregatorV3Mock();
        dpiFeed.setPrice(0.1 ether);

        oracle = new BedOracle(
            bed,
            wbtc,
            weth,
            dpi,
            IChainlinkAggregatorV3(address(btcFeed)),
            IChainlinkAggregatorV3(address(dpiFeed))
        );
    }

    function test_getPrice() public {
        uint256 price = oracle.getPrice();

        uint256 wbtcValue = uint(bed.getDefaultPositionRealUnit(wbtc))*10**10 * uint(btcFeed.latestAnswer()) / 1 ether;
        uint256 dpiValue = uint(bed.getDefaultPositionRealUnit(dpi)) * uint(dpiFeed.latestAnswer()) / 1 ether;
        uint256 wethValue = uint(bed.getDefaultPositionRealUnit(weth));

        uint256 expectedPrice = wbtcValue + dpiValue + wethValue;

        assertEq(price, expectedPrice);
    }
}
