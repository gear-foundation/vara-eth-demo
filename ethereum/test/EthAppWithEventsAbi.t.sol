// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {VaraEthDemoAbi} from "src/VaraEthDemoAbi.sol";

contract VaraEthDemoAbiTest is Test {
    VaraEthDemoAbi public varaEthDemoAbi;

    function setUp() public {
        varaEthDemoAbi = new VaraEthDemoAbi();
    }

    function test_Init() public {
        varaEthDemoAbi.init(false, 5);
    }
}
