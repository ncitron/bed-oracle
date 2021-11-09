// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { IBedOracle } from "./interfaces/IBedOracle.sol";
import { IFToken } from "./interfaces/IFToken.sol";


/// @title FuseBedOracle
/// @author ncitron
/// @notice Price oracle for BED on Fuse
/// @dev Consumes prices from BedOracle but conforms to the correct interfaces for Fuse
contract FuseBedOracle {
    
    /// @notice The BedOracle contract
    IBedOracle public bedOracle;

    /// @notice The BED token
    address public bed;

    /// @notice Creates a new BED price oracle for Fuse
    /// @param _bedOracle The generic BedOracle contract
    /// @param _bed The BED token address
    constructor(IBedOracle _bedOracle, address _bed) {
        bedOracle = _bedOracle;
        bed = _bed;
    }

    /// @notice Gets the price of BED in ETH
    /// @param _underlying The undelrlying token to get the price of. In this case it is always BED
    /// @return The current price of BED in ETH
    function price(address _underlying) external view returns (uint256) {
        require(_underlying == bed, "oracle not found");
        return bedOracle.getPrice();
    }

    /// @notice Gets the price of BED in ETH
    /// @param _fToken The fToken whose underlying to fetch the price of. In this case it is always fBED
    /// @return The current price of BED in ETH
    function getUnderlyingPrice(IFToken _fToken) external view returns (uint256) {
        require(_fToken.underlying() == bed, "oracle not found");
        return bedOracle.getPrice();
    }
}