// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SkyMeadowWrapper} from "../src/SkyMeadowWrapper.sol";
import {SkyMeadow} from "../src/Temp.sol";

contract SkyMeadowDeployer is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        console.log("Deploying SkyMeadowWrapper...");
        SkyMeadowWrapper skyMeadowWrapper = new SkyMeadowWrapper();
        console.log("SkyMeadowWrapper deployed to:", address(skyMeadowWrapper));
       // string memory html = skyMeadowWrapper.getSkyMeadowHTML(1);

        // string memory fileName = string.concat("skyMeadow", ".txt");
        // string memory filePath = string.concat("output/", fileName);
        
        // vm.writeFile(filePath, html);

        vm.stopBroadcast();
    }
}