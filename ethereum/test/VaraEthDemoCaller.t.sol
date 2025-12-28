// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {VaraEthDemoAbi} from "src/VaraEthDemoAbi.sol";
import {VaraEthDemoCaller} from "src/VaraEthDemoCaller.sol";

contract VaraEthDemoCallerTest is Test {
    VaraEthDemoCaller public varaEthDemoCaller;

    function setUp() public {
        varaEthDemoCaller = new VaraEthDemoCaller(new VaraEthDemoAbi());
    }

    function test_Init() public {
        varaEthDemoCaller.init(5);
    }
}
