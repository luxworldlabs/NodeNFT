//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTNode is ERC721Enumerable, Pausable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    string public baseExtension = ".json";
    Counters.Counter private _tokenIdCounter;
    struct infoNode{
        uint8 qualityVa;
    }

    mapping(uint256 => infoNode) public infoNodeList;

    constructor() ERC721("NFT Node", "Node") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://metadata.lux.world/node/";
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension)) : "";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function batchMint(address toAddress, uint number, uint8 _quality) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        for (uint i = 0; i < number; i++) {
            _tokenIdCounter.increment();
            tokenId = _tokenIdCounter.current();
            _safeMint(toAddress, tokenId);
            infoNodeList[tokenId] = infoNode(_quality);
        }
    }

    function transferWithAmountNft(address _receiverAdd, uint256[] memory _tokenID) public
    {
        for(uint i=0; i < _tokenID.length; i++)
        {
            _transfer(msg.sender, _receiverAdd, _tokenID[i]);
        }
    }

    function viewInfoNode(uint256 _tokenId) external view returns(uint8)
    {
        return (infoNodeList[_tokenId].qualityVa);
    }
}
