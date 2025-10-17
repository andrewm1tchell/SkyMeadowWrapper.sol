# SkyMeadowWrapper.sol
Onchain engine for Sky Meadow

SkyMeadowWrapper.sol (https://etherscan.io/address/0xB666C3F49A462C2DDBC2bdc5A99d3828704Daa7C): 
SkyMeadowWrapper.sol allows you to get the HTML for a Sky Meadow NFT with or without and onchain p5.js library. This utilizes the p5js code on the MitchellsExtension.sol and an onchain version of p5js to create html.
<img width="2722" height="1218" alt="image" src="https://github.com/user-attachments/assets/34bbc6f4-520e-497a-8cb4-69c47c1c496e" />

The Sky Meadow Javascript code, which is ~50,000 characters long, is stored on an Ethereum smart contract called <a target="_blank" href="https://etherscan.io/address/0x534514948a28bc76B8F2f2f6B6C1745329375710#readContract#F8" title="Etherscan">MitchellsExtension.sol</a>.
                Additionally, the name, unique hash, and attributes for each piece are stored on that same contract. 
                Querying "GetScriptChunk" with the Sky Meadow contract address as the "creator" (0x8452ee9a2fc4e80c53b33a2b38824c7976744521), 1 as the "series", and 0 as the "index", will return a guide for how to view this data:
<img width="2500" height="808" alt="image" src="https://github.com/user-attachments/assets/03b1a400-dcef-4df3-8a4f-1fcb8557690a" />

 The main Sky Meadow contract is a Manifold <a href="https://manifold.xyz/" title="Manifold" target="_blank">contract</a>. The TokenUri of the SkyMeadow.sol contract <a href="https://etherscan.io/address/0x8452ee9a2fc4e80c53b33a2b38824c7976744521" target="_blank" title="Sky Meadow Contract">here</a> is overridden by the extension contract <a target="_blank" href="https://etherscan.io/address/0x534514948a28bc76B8F2f2f6B6C1745329375710" title="Extension Contract">here</a>. 
                Additionally, the mint function for these tokens was called via the custom extension contract. This allowed me to generate a unique hash at mint-time before calling the overriden mint function. This permanently connects the custom extension contract to the Sky Meadow Manifold contract.
              <img width="2722" height="1218" alt="image" src="https://github.com/user-attachments/assets/ed3043f5-882a-4363-8cf5-2bcebe46f9dd" />
