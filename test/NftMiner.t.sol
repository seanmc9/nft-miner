// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "../src/NftMiner.sol";
import "@openzeppelin/token/ERC721/IERC721.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";
import "@forge-std/console.sol";

contract NftMinerTest is Test {
    IERC721 public constant PUDGEY_ETH_CONTRACT = IERC721(0xBd3531dA5CF5857e7CfAA92426877b022e612cf8);
    uint256 public constant TEST_TOKEN_ID = 4327;
    address public constant OWNER_OF_TEST_TOKEN_ID = 0xd9E912AFCeA495DC8789BD2d6C0004473E48521f;
    uint256 public constant START_BLOCK_NUMBER = 20_370_241;

    NftMiner public nftMiner;

    function setUp() public {
        vm.createSelectFork({urlOrAlias: "https://rpc.ankr.com/eth", blockNumber: START_BLOCK_NUMBER});

        nftMiner = new NftMiner("Test", "TEST", PUDGEY_ETH_CONTRACT);
    }

    function testNftMiner() public {
        vm.roll(START_BLOCK_NUMBER + 1);

        vm.startPrank(OWNER_OF_TEST_TOKEN_ID);
        nftMiner.startMining(TEST_TOKEN_ID);
        console.log(block.timestamp);
        console.log(block.number);

        vm.roll(START_BLOCK_NUMBER + 2);
        console.log(block.timestamp);
        console.log(block.number);

        nftMiner.stopMining(TEST_TOKEN_ID);

        vm.stopPrank();

        assertEq(nftMiner.balanceOf(OWNER_OF_TEST_TOKEN_ID), 1);
    }
}
