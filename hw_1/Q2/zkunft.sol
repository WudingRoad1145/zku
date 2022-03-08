// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract myNFT is ERC721URIStorage{
    using Strings for uint256;
    uint256 constant public totalSupply = 100;
    uint256 private _tokenCounter;

    // nodes = leaves * 2 - 1
    bytes32[totalSupply * 2 - 1] private _merkleTreeNodes; 

    constructor() ERC721("Dwen Dwen", "BDD") {}

    function mintToAddress(address _to) public {
        require(_tokenCounter < totalSupply, "Mint is over!");
        unchecked {
            _tokenCounter++;
        }

        _mint(_to, _tokenCounter);
        string memory _metadata = string(abi.encodePacked(
            "{",
                "\"name\": \"DwenDwen #", _tokenCounter.toString(), "\",",
                "\"description\": \"Edition", _tokenCounter.toString(), " out of ", totalSupply.toString(), '"',
            "}"
            ));
        _setTokenURI(_tokenCounter, _metadata);
        
        // merkle tree
        uint256 _nodeIndex = _tokenCounter - 1;

        _merkleTreeNodes[_nodeIndex] = keccak256(abi.encodePacked(msg.sender, _to, _tokenCounter, _metadata));

        //root hash
        while (_nodeIndex < totalSupply * 2 - 2) {
            // find parent node
            _nodeIndex = _nodeIndex / 2 + totalSupply;

            // update parent node by hashing two children nodes
            _merkleTreeNodes[_nodeIndex] = keccak256(abi.encodePacked(_merkleTreeNodes[(_nodeIndex - totalSupply) * 2],
                                                                      _merkleTreeNodes[(_nodeIndex - totalSupply) * 2 + 1]));
        }
    }

    function getMerkleNode(uint256 _nodeIndex) public view returns (bytes32) {
        return _merkleTreeNodes[_nodeIndex];
    }

    function getMerkleRootHash() public view returns (bytes32) {
        return _merkleTreeNodes[totalSupply * 2 - 2];
    }
}
