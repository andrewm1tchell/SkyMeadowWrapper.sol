// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;
/**
 * @dev Provides a set of functions to operate with Base64 strings.
 */
library Base64 {
    /**
     * @dev Base64 Encoding/Decoding Table
     * See sections 4 and 5 of https://datatracker.ietf.org/doc/html/rfc4648
     */
    string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    string internal constant _TABLE_URL = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

    /**
     * @dev Converts a `bytes` to its Bytes64 `string` representation.
     */
    function encode(bytes memory data) internal pure returns (string memory) {
        return _encode(data, _TABLE, true);
    }

    /**
     * @dev Converts a `bytes` to its Bytes64Url `string` representation.
     */
    function encodeURL(bytes memory data) internal pure returns (string memory) {
        return _encode(data, _TABLE_URL, false);
    }

    /**
     * @dev Internal table-agnostic conversion
     */
    function _encode(bytes memory data, string memory table, bool withPadding) private pure returns (string memory) {
        /**
         * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
         * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
         */
        if (data.length == 0) return "";

        // If padding is enabled, the final length should be `bytes` data length divided by 3 rounded up and then
        // multiplied by 4 so that it leaves room for padding the last chunk
        // - `data.length + 2`  -> Round up
        // - `/ 3`              -> Number of 3-bytes chunks
        // - `4 *`              -> 4 characters for each chunk
        // If padding is disabled, the final length should be `bytes` data length multiplied by 4/3 rounded up as
        // opposed to when padding is required to fill the last chunk.
        // - `4 *`              -> 4 characters for each chunk
        // - `data.length + 2`  -> Round up
        // - `/ 3`              -> Number of 3-bytes chunks
        uint256 resultLength = withPadding ? 4 * ((data.length + 2) / 3) : (4 * data.length + 2) / 3;

        string memory result = new string(resultLength);

        /// @solidity memory-safe-assembly
        assembly {
            // Prepare the lookup table (skip the first "length" byte)
            let tablePtr := add(table, 1)

            // Prepare result pointer, jump over length
            let resultPtr := add(result, 0x20)
            let dataPtr := data
            let endPtr := add(data, mload(data))

            // In some cases, the last iteration will read bytes after the end of the data. We cache the value, and
            // set it to zero to make sure no dirty bytes are read in that section.
            let afterPtr := add(endPtr, 0x20)
            let afterCache := mload(afterPtr)
            mstore(afterPtr, 0x00)

            // Run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                // Advance 3 bytes
                dataPtr := add(dataPtr, 3)
                let input := mload(dataPtr)

                // To write each character, shift the 3 byte (24 bits) chunk
                // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
                // and apply logical AND with 0x3F to bitmask the least significant 6 bits.
                // Use this as an index into the lookup table, mload an entire word
                // so the desired character is in the least significant byte, and
                // mstore8 this least significant byte into the result and continue.

                mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance

                mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance

                mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance

                mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
                resultPtr := add(resultPtr, 1) // Advance
            }

            // Reset the value that was cached
            mstore(afterPtr, afterCache)

            if withPadding {
                // When data `bytes` is not exactly 3 bytes long
                // it is padded with `=` characters at the end
                switch mod(mload(data), 3)
                case 1 {
                    mstore8(sub(resultPtr, 1), 0x3d)
                    mstore8(sub(resultPtr, 2), 0x3d)
                }
                case 2 {
                    mstore8(sub(resultPtr, 1), 0x3d)
                }
            }
        }

        return result;
    }

    /**
     * @dev Converts a Base64 `string` to its `string` representation.
     */
    function decode(string memory input) internal pure returns (string memory) {
        bytes memory data = bytes(input);
        if (data.length == 0) return "";

        // Count padding characters ('=' or 0x3d)
        uint256 paddingCount = 0;
        if (data.length >= 2) {
            if (data[data.length - 1] == 0x3d) paddingCount++;
            if (data[data.length - 2] == 0x3d) paddingCount++;
        }

        // Calculate output length: 3 bytes for every 4 input characters, minus padding
        uint256 outputLength = (data.length * 3) / 4 - paddingCount;
        
        bytes memory output = new bytes(outputLength);
        
        // Create reverse lookup table
        bytes memory reverseLookup = new bytes(256);
        
        // Standard Base64 reverse lookup
        bytes memory tableBytes = bytes(_TABLE);
        for (uint256 i = 0; i < 64; i++) {
            reverseLookup[uint8(tableBytes[i])] = bytes1(uint8(i));
        }
        
        uint256 j = 0;
        uint8 b1;
        uint8 b2;
        uint8 b3;
        uint8 b4;
        
        // Process in blocks of 4 characters
        for (uint256 i = 0; i + 3 < data.length; i += 4) {
            // Skip padding
            if (data[i] == 0x3d) break;
            
            // Convert 4 Base64 chars to 4 6-bit values
            b1 = uint8(reverseLookup[uint8(data[i])]);
            b2 = uint8(reverseLookup[uint8(data[i+1])]);
            b3 = data[i+2] == 0x3d ? 0 : uint8(reverseLookup[uint8(data[i+2])]);
            b4 = data[i+3] == 0x3d ? 0 : uint8(reverseLookup[uint8(data[i+3])]);
            
            // Combine 4 6-bit values into 3 bytes
            if (j < outputLength)
                output[j++] = bytes1(uint8((b1 << 2) | (b2 >> 4)));
                
            if (j < outputLength)
                output[j++] = bytes1(uint8((b2 << 4) | (b3 >> 2)));
                
            if (j < outputLength)
                output[j++] = bytes1(uint8((b3 << 6) | b4));
        }
        
        return string(output);
    }
    
    /**
     * @dev Converts a Base64URL `string` to its `string` representation.
     */
    function decodeURL(string memory input) internal pure returns (string memory) {
        bytes memory data = bytes(input);
        if (data.length == 0) return "";
        
        // Calculate output length: 3 bytes for every 4 input characters
        // For URL encoding, no padding is accounted for
        uint256 outputLength = (data.length * 3) / 4;
        
        // Adjust for incomplete groups
        uint256 remainder = data.length % 4;
        if (remainder == 1) {
            // Invalid Base64URL - single leftover character
            revert("Invalid Base64URL string");
        } else if (remainder == 2) {
            outputLength = outputLength - 2;
        } else if (remainder == 3) {
            outputLength = outputLength - 1;
        }
        
        bytes memory output = new bytes(outputLength);
        
        // Create reverse lookup table
        bytes memory reverseLookup = new bytes(256);
        
        // URL-safe Base64 reverse lookup
        bytes memory tableBytes = bytes(_TABLE_URL);
        for (uint256 i = 0; i < 64; i++) {
            reverseLookup[uint8(tableBytes[i])] = bytes1(uint8(i));
        }
        
        uint256 j = 0;
        uint8 b1;
        uint8 b2;
        uint8 b3;
        uint8 b4;
        
        // Process in blocks of 4 characters (handling final partial block separately)
        for (uint256 i = 0; i + 3 < data.length; i += 4) {
            // Convert 4 Base64URL chars to 4 6-bit values
            b1 = uint8(reverseLookup[uint8(data[i])]);
            b2 = uint8(reverseLookup[uint8(data[i+1])]);
            b3 = uint8(reverseLookup[uint8(data[i+2])]);
            b4 = uint8(reverseLookup[uint8(data[i+3])]);
            
            // Combine 4 6-bit values into 3 bytes
            if (j < outputLength)
                output[j++] = bytes1(uint8((b1 << 2) | (b2 >> 4)));
                
            if (j < outputLength)
                output[j++] = bytes1(uint8((b2 << 4) | (b3 >> 2)));
                
            if (j < outputLength)
                output[j++] = bytes1(uint8((b3 << 6) | b4));
        }
        
        // Handle final partial block if present
        if (remainder > 1) {
            b1 = uint8(reverseLookup[uint8(data[data.length - remainder])]);
            b2 = uint8(reverseLookup[uint8(data[data.length - remainder + 1])]);
            
            output[j++] = bytes1(uint8((b1 << 2) | (b2 >> 4)));
            
            if (remainder == 3) {
                b3 = uint8(reverseLookup[uint8(data[data.length - 1])]);
                output[j++] = bytes1(uint8((b2 << 4) | (b3 >> 2)));
            }
        }
        
        return string(output);
    }
}