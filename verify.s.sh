#!/bin/bash

# Load environment variables
source .env

# Verify ColorEngine
forge verify-contract 0xB666C3F49A462C2DDBC2bdc5A99d3828704Daa7C src/SkyMeadowWrapper.sol:SkyMeadowWrapper --chain-id 1 --etherscan-api-key $ETHERSCAN_API_KEY

# Verify RandomGenerator
forge verify-contract 0xbc0dc64b07a01d7fa722f3fefff825c7892b260d src/RandomGenerator.sol:RandomGenerator --chain-id 1 --etherscan-api-key $ETHERSCAN_API_KEY

# Verify PopupAnimEngine1
forge verify-contract 0x45FeBff75E87fd42a6105e63EBe90578B20a0B5A src/PopupAnimEngine1.sol:PopupAnimEngine1 --constructor-args $(cast abi-encode "constructor(address,address)" 0xbc0dc64b07a01d7fa722f3fefff825c7892b260d 0xe6bF3b1c65f287B3CEB4E2Df6921a05726DFa1d8) --chain-id 1 --etherscan-api-key $ETHERSCAN_API_KEY

# Verify PopupAnimEngine2
forge verify-contract 0x91a28683e28b22CA4533d5A8Ff58e1861Ce37892 src/PopupAnimEngine2.sol:PopupAnimEngine2 --constructor-args $(cast abi-encode "constructor(address,address)" 0xbc0dc64b07a01d7fa722f3fefff825c7892b260d 0xe6bF3b1c65f287B3CEB4E2Df6921a05726DFa1d8) --chain-id 1 --etherscan-api-key $ETHERSCAN_API_KEY

# Verify PopupImageEngine
forge verify-contract 0xDfd90153c4582Bcc0527c43CD10b0089Ac1F7afc src/PopupImageEngine.sol:PopupImageEngine --constructor-args $(cast abi-encode "constructor(address,address)" 0xbc0dc64b07a01d7fa722f3fefff825c7892b260d 0xe6bF3b1c65f287B3CEB4E2Df6921a05726DFa1d8) --chain-id 1 --etherscan-api-key $ETHERSCAN_API_KEY

# Verify Colors
# forge verify-contract 0xC61B69466D40A19974Efc235879c1B5C5ceB1e8b src/Colors.sol:Colors --chain-id 1 --etherscan-api-key $ETHERSCAN_API_KEY

# Verify PopupExtension
forge verify-contract 0x981d04E3B2a88dd6674b16fFE65C8e050c3018fC src/PopupExtension.sol:PopupExtension --constructor-args $(cast abi-encode "constructor(address,address,address,address,address,uint256)" 0xDfd90153c4582Bcc0527c43CD10b0089Ac1F7afc 0x45FeBff75E87fd42a6105e63EBe90578B20a0B5A 0xF135e313fD3DAdf77aA6E7F7887634A720e7F248 0xe6bF3b1c65f287B3CEB4E2Df6921a05726DFa1d8 0xC61B69466D40A19974Efc235879c1B5C5ceB1e8b 50000000000000000) --chain-id 1 --etherscan-api-key $ETHERSCAN_API_KEY 