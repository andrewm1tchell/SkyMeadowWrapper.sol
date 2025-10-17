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
contract DeployExtension is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        ColorEngine colorEngine = new ColorEngine();
        console.log("ColorEngine deployed to:", address(colorEngine));
        RandomGenerator randomGenerator = new RandomGenerator();
        console.log("RandomGenerator deployed to:", address(randomGenerator));
        PopupAnimEngine1 popupAnimEngine1 = new PopupAnimEngine1(address(randomGenerator), address(colorEngine));
        console.log("PopupAnimEngine1 deployed to:", address(popupAnimEngine1));
        PopupAnimEngine2 popupAnimEngine2 = new PopupAnimEngine2(address(randomGenerator), address(colorEngine));
        console.log("PopupAnimEngine2 deployed to:", address(popupAnimEngine2));
        PopupImageEngine popupImageEngine = new PopupImageEngine(address(randomGenerator), address(colorEngine));
        console.log("PopupImageEngine deployed to:", address(popupImageEngine));
        Colors colors = new Colors();
        console.log("Colors deployed to:", address(colors));
        
        PopupExtension extension = new PopupExtension(
            address(popupImageEngine),
            address(popupAnimEngine1),
            address(popupAnimEngine2),
            address(colorEngine),
            address(colors),
            0.01 ether
        );
        console.log("PopupExtension deployed to:", address(extension));
        popupAnimEngine1.grantAccess(address(extension));
        popupAnimEngine2.grantAccess(address(extension));
        popupImageEngine.grantAccess(address(extension));
        colorEngine.grantAccess(address(extension));
        //extension.unpause();
        extension.setName("Popup");
        extension.setDescription(
"Life is full of distractions. Some we avoid, like a popup advertisement or a billboard on the side of the road. A few places in America have gone so far as to ban billboards. And yet, strip out the messaging from a popup and it just becomes a blank canvas...('-')? Popup is fully on-chain. The image is svg generated from the contract. The animation is created with vanilla javascript, fed into an html string along with a unique color palette stored stored on a separate contract."
            );
        extension.setCreator(0x3f980286960c68957a89903DeCfaEE4b34e45046);
        vm.stopBroadcast();
    }
}