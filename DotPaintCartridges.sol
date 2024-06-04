// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

// ::::::::::::::::         :::::::::::::::::::::    :::::::::::::::::::::
// ::::::::::::::::         :::::::::::::::::::::    :::::::::::::::::::::
// :::::::::::::::::::::    :::::::::::::::::::::    :::::::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::    ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::    ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::     :::::::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::::::::::::    :::::::::::::::::::::         :::::::::::         ::::::::::::::::
// ::::::::::::::::         :::::::::::::::::::::         :::::::::::         ::::::::::::::::
// ::::::::::::::::         :::::::::::::::::::::         :::::::::::         ::::::::::::::::

contract DotPaintCartridges is ERC721URIStorage, Ownable, ReentrancyGuard {
    string private _baseContractURI = "https://nft.dot.fan/ipfs/Qmd5kgbo7yAHW3v3UKgkf8iAAhVmZbxHQAtkJr7ZsdRcU4";
    uint256 private _nextTokenId = 0;
    bool private _initialized = false;

    constructor(address initialOwner) Ownable(initialOwner) ERC721("Dot Paint Cartridge", "DOTPC") {
        require(!_initialized, "Already initialized");
        _initialized = true;
    }

    function contractURI() public view returns (string memory) {
        return _baseContractURI;
    }

    function setContractURI(
        string memory newContractURI
    ) public onlyOwner() nonReentrant() returns (string memory) {
        _baseContractURI = newContractURI;

        return _baseContractURI;
    }

    function mint(address collector, string memory tokenURI) public onlyOwner() returns (uint256) {
        _nextTokenId++;
        uint256 tokenId = _nextTokenId;
        _mint(collector, tokenId);
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }
}