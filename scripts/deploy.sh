#!/usr/bin/env bash

ORACLE=$(dapp create BedOracle $BED $WBTC $WETH $DPI $BTC_FEED $DPI_FEED)
$(dapp verify-contract src/BedOracle.sol:BedOracle $ORACLE $BED $WBTC $WETH $DPI $BTC_FEED $DPI_FEED)