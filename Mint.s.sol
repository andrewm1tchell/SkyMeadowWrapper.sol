// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PopupExtension} from "../src/PopupExtension.sol";
import {PopupAnimEngine1} from "../src/PopupAnimEngine1.sol";
import {PopupAnimEngine2} from "../src/PopupAnimEngine2.sol";
import {PopupImageEngine} from "../src/PopupImageEngine.sol";
import {ColorEngine} from "../src/ColorEngine.sol";
import {RandomGenerator} from "../src/RandomGenerator.sol";
import {Colors} from "../src/Colors.sol";
contract Mint is Script {
    function run() public {
        console.log("Starting mint...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
       
        PopupExtension extension = PopupExtension(0x29F4a3AbA60c43D5cd5f1170192c568344c68a3A);
        extension.mint{value: 0.01 ether}(0xF1Da6E2d387e9DA611dAc8a7FC587Eaa4B010013);
        vm.stopBroadcast();
    }
}