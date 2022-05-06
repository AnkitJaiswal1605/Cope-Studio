// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Cope is ERC721, Ownable {

    using Strings for uint256;

    uint public constant MAX_SUPPLY = 3000;
    uint public price = 0.1 ether;
    uint public tokenId = 1;
    mapping(address => uint) public nftBalance;
    string _baseUri;
    string _contractUri;

    constructor() ERC721("Cope Studio", "COPE") {
        _contractUri = "ipfs://QmbPMcQQGb4dZdQtfNqYdiech2wzDP8Fq8vrBjeUuJyBdE/space_doge_contract_uri.json";
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _tokenId.toString(),".json")) : '';
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }

    function mint() public payable {
        require(msg.value >= price, "Ether sent is not sufficient.");
        require(tokenId <= MAX_SUPPLY, "Sold out!");
        require(nftBalance[msg.sender] == 0, "User already owns an NFT!");
        _safeMint(msg.sender, tokenId);
        tokenId++;
        nftBalance[msg.sender] = 1;
    }

    function contractURI() public view returns (string memory) {
        return _contractUri;
    }
    
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseUri = newBaseURI;
    }
    
    function setContractURI(string memory newContractURI) external onlyOwner {
        _contractUri = newContractURI;
    }

    function setPrice(uint newPrice) external onlyOwner {
        price = newPrice;
    }
    
    function withdrawAll() external onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }
}
