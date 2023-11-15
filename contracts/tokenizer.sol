// SPDX-License-Identifer: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721.sol";

contract TokenMaster is ERC721 {

    constructor(
        string _name, 
        string memory _symbol) ERC721(_name, _symbol) {

            
    }
}