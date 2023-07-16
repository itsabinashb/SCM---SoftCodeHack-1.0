//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/SCM.sol";

contract MyScript is Script {
    function run() external {
        uint256 key = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(key);
        SCM scm = new SCM();
        vm.stopBroadcast();
    }
}


// https://sepolia.etherscan.io/address/0xf4a999a76d521d11a03f901ec9f16f1987dab40c