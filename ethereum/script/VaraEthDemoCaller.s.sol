// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {VaraEthDemoAbiScript} from "./VaraEthDemoAbi.s.sol";
import {IVaraEthDemo, VaraEthDemoCaller} from "src/VaraEthDemoCaller.sol";

contract VaraEthDemoCallerScript is VaraEthDemoAbiScript {
    function setUp() public override {}

    function run() public override {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(privateKey);
        vm.startBroadcast(privateKey);

        if (hasEnv()) {
            (address routerAddress, bytes32 validatedCodeId, uint128 initialExecutableBalance) = parseEnv();

            address varaEthDemoCallerAddress =
                vm.computeCreateAddress(deployerAddress, vm.getNonce(deployerAddress) + 4);

            address mirror = deployAbiWithInitializer(routerAddress, validatedCodeId, varaEthDemoCallerAddress);
            executableBalanceTopUp(mirror, initialExecutableBalance);

            VaraEthDemoCaller varaEthDemoCaller = new VaraEthDemoCaller(IVaraEthDemo(mirror));
            varaEthDemoCaller.init(5);
        } else if (vm.envExists("VARA_ETH_PROGRAM")) {
            address varaEthProgram = vm.envAddress("VARA_ETH_PROGRAM");

            new VaraEthDemoCaller(IVaraEthDemo(varaEthProgram));
        } else {
            revert();
        }

        vm.stopBroadcast();
    }
}
