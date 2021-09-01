// SPDX-License-Identifier: MIT
// https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts-upgradeable/master/contracts/proxy/beacon/IBeaconUpgradeable.sol

pragma solidity ^0.8.0;

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeaconUpgradeable {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}
