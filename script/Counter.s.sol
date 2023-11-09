// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";

import {LPTracker} from "src/LPTracker.sol";

contract Deploy is Script {
    function run() external returns (LPTracker lptracker) {
        vm.startBroadcast();
        lptracker = new LPTracker(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
        vm.stopBroadcast();
    }
}
