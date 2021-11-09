// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import { BedOracle } from "../BedOracle.sol";
import { ChainlinkAggregatorV3Mock } from "../mocks/ChainlinkAggregatorV3Mock.sol";
import { FTokenMock } from "../mocks/FTokenMock.sol";
import { FuseBedOracle } from "../FuseBedOracle.sol";
import { IBedOracle } from "../interfaces/IBedOracle.sol";
import { IChainlinkAggregatorV3 } from "../interfaces/IChainlinkAggregatorV3.sol";
import { IFToken } from "../interfaces/IFToken.sol";
import { SetTokenMock } from "../mocks/SetTokenMock.sol";


contract BedOracleTest is DSTest {

    FuseBedOracle fuseOracle;
    BedOracle bedOracle;

    SetTokenMock bed;
    FTokenMock fBed;
    
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

        bedOracle = new BedOracle(
            bed,
            wbtc,
            weth,
            dpi,
            IChainlinkAggregatorV3(address(btcFeed)),
            IChainlinkAggregatorV3(address(dpiFeed))
        );

        fBed = new FTokenMock(address(bed));
        fuseOracle = new FuseBedOracle(IBedOracle(address(bedOracle)), address(bed));
    }

    function test_price(uint96 btcPrice, uint96 dpiPrice) public {
        btcFeed.setPrice(int(uint(btcPrice)));
        dpiFeed.setPrice(int(uint(dpiPrice)));

        uint256 price = fuseOracle.price(address(bed));
        uint256 expectedPrice = bedOracle.getPrice();

        assertEq(price, expectedPrice);
    }

    function test_getUnderlyingPrice(uint96 btcPrice, uint96 dpiPrice) public {
        btcFeed.setPrice(int(uint(btcPrice)));
        dpiFeed.setPrice(int(uint(dpiPrice)));

        uint256 price = fuseOracle.getUnderlyingPrice(IFToken(address(fBed)));
        uint256 expectedPrice = bedOracle.getPrice();

        assertEq(price, expectedPrice);
    }

    function testFail_priceWrongAsset() public view {
        fuseOracle.price(address(0x34));
    }

    function testFail_getUnderlyingPriceWrongAsset() public view {
        fuseOracle.getUnderlyingPrice(IFToken(address(0x83)));
    }
}
