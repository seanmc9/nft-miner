// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import "@openzeppelin/token/ERC721/IERC721.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";

contract NftMiner is ERC20 {
    IERC721 public underlyingNft;
    mapping(uint256 => uint256) public isMining;

    error MustOwnTokenId(uint256 tokenId);
    error TokenMustBeMining();

    constructor(string memory name_, string memory symbol_, IERC721 underlyingNft_) ERC20(name_, symbol_) {
        underlyingNft = underlyingNft_;
    }

    function startMining(uint256 tokenId) public {
        if (underlyingNft.ownerOf(tokenId) != msg.sender) revert MustOwnTokenId(tokenId);

        isMining[tokenId] = block.number;
    }

    function stopMining(uint256 tokenId) public {
        if (underlyingNft.ownerOf(tokenId) != msg.sender) revert MustOwnTokenId(tokenId);
        if (isMining[tokenId] == 0) revert TokenMustBeMining();

        _mint(msg.sender, (block.number - isMining[tokenId]) * 1 ether);
        isMining[tokenId] = 0;
    }
}
