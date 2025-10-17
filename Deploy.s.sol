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
contract Deploy is Script {
    function run() public {
        console.log("Starting deployment...");
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        ColorEngine colorEngine = ColorEngine(0xe6bF3b1c65f287B3CEB4E2Df6921a05726DFa1d8);
        RandomGenerator randomGenerator = RandomGenerator(0xbC0dC64B07A01D7FA722F3fEfFF825C7892B260D);
        console.log("RandomGenerator deployed to:", address(randomGenerator));
        PopupAnimEngine1 popupAnimEngine1 = PopupAnimEngine1(0x45FeBff75E87fd42a6105e63EBe90578B20a0B5A);
        PopupAnimEngine2 popupAnimEngine2 = new PopupAnimEngine2(address(randomGenerator), address(colorEngine));
        console.log("PopupAnimEngine2 deployed to:", address(popupAnimEngine2));
                console.log("PopupAnimEngine1 deployed to:", address(popupAnimEngine1));

        PopupImageEngine popupImageEngine = PopupImageEngine(0xDfd90153c4582Bcc0527c43CD10b0089Ac1F7afc);
        console.log("PopupImageEngine deployed to:", address(popupImageEngine));
        Colors colors = Colors(0xC61B69466D40A19974Efc235879c1B5C5ceB1e8b);
        console.log("Colors deployed to:", address(colors));
        
        PopupExtension extension = PopupExtension(0x981d04E3B2a88dd6674b16fFE65C8e050c3018fC);
        console.log("PopupExtension deployed to:", address(extension));
        extension.setPopupAnimEngine2(address(popupAnimEngine2));
//         popupAnimEngine1.grantAccess(address(extension));
//         popupAnimEngine2.grantAccess(address(extension));
//         popupImageEngine.grantAccess(address(extension));
//         colorEngine.grantAccess(address(extension));
//        // extension.unpause();
//         extension.setName("Popup");
//         extension.setDescription(
// "Life is full of distractions. Some we avoid, like a popup advertisement or a billboard on the side of the road. A few places in America have gone so far as to ban billboards. And yet, strip out the messaging from a popup and it just becomes a blank canvas...('-')? Popup is fully on-chain. The image is svg generated from the contract. The animation is created with vanilla javascript, fed into an html string along with a unique color palette stored stored on a separate contract."
//             );
//         extension.setCreator(0x40eA935Bff2D4E8705A9664D47ce9BBADbA2b96E);
        vm.stopBroadcast();
    }
}