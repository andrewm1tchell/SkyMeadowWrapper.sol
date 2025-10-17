// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Utils.sol";
import "./Base64.sol";

//@developed by andrew mitchell (andrewmitchell.eth)
//This utilizes the p5js code on the Sky Meadow Extension contract(0x534514948a28bc76B8F2f2f6B6C1745329375710) and the p5.js library(0x16cc845d144A283D1b0687FBAC8B0601cC47A6C3) to create html.
//This is a wrapper for creating animation urls for Sky Meadow NFTs(0x8452ee9A2Fc4e80C53b33a2B38824C7976744521).
contract SkyMeadowWrapper {
    address public owner;
    address public constant SKY_MEADOW_EXTENSION_CONTRACT = 0x534514948a28bc76B8F2f2f6B6C1745329375710;
    address public constant P5JS_LIBRARY_CONTRACT = 0x16cc845d144A283D1b0687FBAC8B0601cC47A6C3;
    address public constant SKY_MEADOW_NFT_CONTRACT = 0x8452ee9A2Fc4e80C53b33a2B38824C7976744521;
    string public constant P5JS_SCRIPT_URL = "https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.2/p5.min.js";

    string public howToText = 
               "SKY MEADOW WRAPPER USAGE GUIDE:\n\n"
               "Created by Andrew Mitchell\n\n"
               "This is a wrapper for the Sky Meadow Extension contract and the p5.js library contract. It allows you to get the HTML for a Sky Meadow NFT with or without and onchain p5.js library.\n"
               "This utilizes the p5js code on the Sky Meadow Extension contract(0x534514948a28bc76B8F2f2f6B6C1745329375710) and the p5.js library(0x16cc845d144A283D1b0687FBAC8B0601cC47A6C3) to create html.\n\n"
               "FUNCTIONS:\n"
               "1. a_howTo() - Returns this guide\n"
               "2. b_getSkyMeadowHTMLWithOffChainP5JSBase64(uint256 tokenId) - Returns Base64 encoded data URI using default external p5.js CDN.\n"
               "3. c_getSkyMeadowHTMLWithOffChainP5JSBase64Custom(uint256 tokenId, string p5jsScriptTag) - Returns Base64 encoded data URI using custom external p5.js CDN. Provide your own script tag.\n"
               "4. d_getSkyMeadowHTMLWithOnChainP5JSBase64_ThisWillLikelyRunOutOfGasButMaybeInTheFutureItWorks(uint256 tokenId) - Returns Base64 encoded data URI. WARNING: May run out of gas on mainnet.\n"
               "5. e_getSkyMeadowHTMLWithOffChainP5JS(uint256 tokenId) - Returns HTML using default external p5.js CDN. (If using Etherscan: Read Contract tab, output will have extra spaces/newlines that break the HTML)\n"
               "6. f_getSkyMeadowHTMLWithOffChainP5JSCustom(uint256 tokenId, string p5jsScriptTag) - Returns HTML using custom external p5.js CDN. Provide your own script tag. (If using Etherscan: Read Contract tab, output will have extra spaces/newlines that break the HTML)\n"
               "7. g_getSkyMeadowHTMLWithOnChainP5JS(uint256 tokenId) - Returns HTML using on-chain p5.js library. (If using Etherscan: Read Contract tab, output will have extra spaces/newlines that break the HTML)\n\n"
               "IMPORTANT NOTES:\n"
               "- Token IDs must be between 1 and 555\n"
               "- For #5, #6, and #7: Use Remix IDE, Forge, or a custom client instead of Etherscan Read Contract tab to get the full HTML without garbage added by Etherscan.\n"
               "- For #4: This will likely run out of gas on mainnet. If you want to try it, you can use a custom client instead of Etherscan Read Contract tab.\n"
               "- For #2 and #3: If you want to use a custom p5.js CDN, you can provide your own script tag. For example, https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.2/p5.min.js \n"
               "- This contract is also documented on the Sky Meadow Extension contract: https://etherscan.io/address/0x534514948a28bc76B8F2f2f6B6C1745329375710#readContract\n";

    constructor() {
        owner = msg.sender;
    }

    function a_howTo() public view returns (string memory) {
        return howToText;
    }

    function b_getSkyMeadowHTMLWithOffChainP5JSBase64(uint256 tokenId) public view returns (string memory) {
        return string(abi.encodePacked("data:text/html;base64,", Base64.encode(bytes(_getSkyMeadowHTMLWithOffChainP5JS(tokenId, P5JS_SCRIPT_URL)))));
    }

    function c_getSkyMeadowHTMLWithOffChainP5JSBase64Custom(uint256 tokenId, string memory p5jsScriptTag) public view returns (string memory) {
        return string(abi.encodePacked("data:text/html;base64,", Base64.encode(bytes(_getSkyMeadowHTMLWithOffChainP5JS(tokenId, p5jsScriptTag)))));
    }

    function d_getSkyMeadowHTMLWithOnChainP5JSBase64_ThisWillLikelyRunOutOfGasButMaybeInTheFutureItWorks(uint256 tokenId) public view returns (string memory) {
        return string(abi.encodePacked("data:text/html;base64,", Base64.encode(bytes(_getSkyMeadowHTML(tokenId)))));
    }

    function e_getSkyMeadowHTMLWithOffChainP5JS(uint256 tokenId) public view returns (string memory) {
        require(tokenId > 0, "Token ID must be greater than 0");
        require(tokenId < 556, "Token ID must be less than 556");
        
        return _getSkyMeadowHTMLWithOffChainP5JS(tokenId, P5JS_SCRIPT_URL);
    }

    function f_getSkyMeadowHTMLWithOffChainP5JSCustom(uint256 tokenId, string memory p5jsScriptTag) public view returns (string memory) {
        require(tokenId > 0, "Token ID must be greater than 0");
        require(tokenId < 556, "Token ID must be less than 556");
        
        return _getSkyMeadowHTMLWithOffChainP5JS(tokenId, p5jsScriptTag);
    }

    function g_getSkyMeadowHTMLWithOnChainP5JS(uint256 tokenId) public view returns (string memory) {
        return _getSkyMeadowHTML(tokenId);
    }

    function setHowToText(string memory newHowToText) public {
        require(msg.sender == owner, "Only owner can set how to text");
        howToText = newHowToText;
    }

    function _getSkyMeadowHTMLWithOffChainP5JS(uint256 tokenId, string memory p5jsScriptTag) private view returns (string memory) {
        string memory tokenIdAsString = Utils.toString(tokenId);
        string memory tokenIdAsStringMinusOne = Utils.toString(tokenId - 1);
        string memory metadataArray = "";
        string memory artScript = "";
        metadataArray = ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 2);
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 3)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 4)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 5)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 6)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 7)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 8)));
        artScript = ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 1);
        
        string memory anim = string(abi.encodePacked(
            "<!doctypehtml><html lang=en><meta content='text/html; charset=UTF-8'http-equiv=Content-Type'><meta content='width=device-width,initial-scale=1'name=viewport><meta content='ie=edge'http-equiv=X-UA-Compatible><meta artist='Andrew Mitchell'><title>Sky Meadow #",
            tokenIdAsString,
            "</title><head><script src=\"", 
            p5jsScriptTag,
            "\"></script><script>", 
            metadataArray,
            "var hash=metadata[",
            tokenIdAsStringMinusOne,
            "].hash;",
            "</script>",
            "</head><body>",
            "<main></main>",
            "<script>",
            artScript,
            "</script>",
            "<style>body,html{margin:0;padding:0;overflow:hidden}canvas{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%)}.my-img{display:block;margin:auto;max-width:100%;max-height:100%}</style></body></html>"
        ));

        return anim;
    }

    function _getSkyMeadowHTML(uint256 tokenId) private view returns (string memory) {
        require(tokenId > 0, "Token ID must be greater than 0");
        require(tokenId < 556, "Token ID must be less than 556");
        
        string memory tokenIdAsString = Utils.toString(tokenId);
        string memory tokenIdAsStringMinusOne = Utils.toString(tokenId - 1);
        string memory metadataArray = "";
        string memory p5jsScript = "";
        string memory artScript = "";
        p5jsScript = IP5js(P5JS_LIBRARY_CONTRACT).readLibrary("p5.js 1.4.2");
        metadataArray = ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 2);
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 3)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 4)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 5)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 6)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 7)));
        metadataArray = string(abi.encodePacked(metadataArray, ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 8)));
        artScript = ISkyMeadow(SKY_MEADOW_EXTENSION_CONTRACT).getScriptChunk(SKY_MEADOW_NFT_CONTRACT, 1, 1);
        
        string memory anim = string(abi.encodePacked(
            "<!doctypehtml><html lang=en><meta content='text/html; charset=UTF-8'http-equiv=Content-Type'><meta content='width=device-width,initial-scale=1'name=viewport><meta content='ie=edge'http-equiv=X-UA-Compatible><meta artist='Andrew Mitchell'><title>Sky Meadow #",
            tokenIdAsString,
            "</title><head><script>", 
            metadataArray,
            "var hash=metadata[",
            tokenIdAsStringMinusOne,
            "].hash;",
            "</script>",
            "<script>",
            p5jsScript,
            "</script>",
            "</head><body>",
            "<main></main>",
            "<script>",
            artScript,
            "</script>",
            "<style>body,html{margin:0;padding:0;overflow:hidden}canvas{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%)}.my-img{display:block;margin:auto;max-width:100%;max-height:100%}</style></body></html>"
        ));

        return anim;
    }
}

interface ISkyMeadow {
    function getScriptChunk(address creator, uint256 series, uint256 index) external view returns (string memory);
}

interface IP5js {
    function readLibrary(string memory libraryName) external view returns (string memory);
}