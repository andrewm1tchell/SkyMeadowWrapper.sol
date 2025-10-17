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
contract GetImage is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        ColorEngine colorEngine = new ColorEngine();
        console.log("ColorEngine deployed to:", address(colorEngine));
        colorEngine.addColorPalette("test","#c8c699,#c4c292,#cbc895,#2c6d41,#2b693f,#2b6e40,#5fa595,#60a393,#8e3f1a,#8a3d19,#c22d3b,#9fb46d,#2a1616,#c08047",0,msg.sender);

        RandomGenerator randomGenerator = new RandomGenerator();
        console.log("RandomGenerator deployed to:", address(randomGenerator));
        PopupAnimEngine1 popupAnimEngine1 = new PopupAnimEngine1(address(randomGenerator), address(colorEngine));
        console.log("PopupAnimEngine1 deployed to:", address(popupAnimEngine1));
        PopupAnimEngine2 popupAnimEngine2 = new PopupAnimEngine2(address(randomGenerator), address(colorEngine));
        console.log("PopupAnimEngine2 deployed to:", address(popupAnimEngine2));
        PopupImageEngine popupImageEngine = new PopupImageEngine(address(randomGenerator), address(colorEngine));
        console.log("PopupImageEngine deployed to:", address(popupImageEngine));
        bytes32 hash = keccak256(abi.encodePacked(
            block.timestamp,
            block.prevrandao,
            msg.sender
        ));
        string memory image = popupImageEngine.getImage(0, hash);

        string memory fileName = string.concat("svg", ".html");
        string memory filePath = string.concat("output/", fileName); 
        
        vm.writeFile(filePath, image);
        
        vm.stopBroadcast();
    }
}