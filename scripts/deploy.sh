#!/usr/bin/env bash

BED_ORACLE=$(dapp create BedOracle $BED $WBTC $WETH $DPI $BTC_FEED $DPI_FEED)
! dapp verify-contract src/BedOracle.sol:BedOracle $BED_ORACLE $BED $WBTC $WETH $DPI $BTC_FEED $DPI_FEED

FUSE_BED_ORACLE=$(dapp create FuseBedOracle $BED_ORACLE $BED)
! dapp verify-contract src/FuseBedOracle.sol:FuseBedOracle $FUSE_BED_ORACLE $BED_ORACLE $BED

echo "deployments complete"
echo "BED Oracle: $BED_ORACLE"
echo "Fuse BED Oracle: $FUSE_BED_ORACLE"