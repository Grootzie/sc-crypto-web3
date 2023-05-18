// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

 /// @author Groot#6879 

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CryptoProject is ERC721A, Ownable,ReentrancyGuard{
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 120;
    uint256 public constant SALE_PRICE = 12 ether;
    uint256 public constant MAX_PER_ADRESS_PUBLIC_MINT = 2;
    uint256 public constant QUANTITY_MINTED = 2;
    uint256 public constant MAX_TEAM_MINT = 2;

    address payable public withdrawalAddress;
    string private  baseTokenUri;

    enum Step {
        Before,
        PublicSale
    }
    Step public Currentstep;

    constructor(address payable _withdrawalAddress) ERC721A("CryptoProject", "CRYPTO",MAX_PER_ADRESS_PUBLIC_MINT,MAX_SUPPLY) {
        withdrawalAddress = _withdrawalAddress;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "CryptoProject :: Cannot be called by a contract");
        _;
    }

    function mint() external payable nonReentrant callerIsUser{
        require(Currentstep == Step.PublicSale, "CryptoProject :: Not Yet Active.");
        require((totalSupply() + QUANTITY_MINTED) <= MAX_SUPPLY, "CryptoProject :: Beyond Max Supply");
        require(msg.value >= (SALE_PRICE * QUANTITY_MINTED), "CryptoProject :: Payment is below the price");

        _safeMint(msg.sender, QUANTITY_MINTED);
    }

    function dev(address to, uint256 _quantity) external onlyOwner{ 
        require((totalSupply() + _quantity) <= MAX_SUPPLY, "CryptoProject :: Cannot mint beyond max supply");
        _safeMint(to, _quantity);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenUri;
    }

    //return uri for certain token
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, tokenId.toString(), ".json")) : "";
    }

    /// @dev walletOf() function shouldn't be called on-chain due to gas consumption
    function walletOf() external view returns(uint256[] memory){
        address _owner = msg.sender;
        uint256 numberOfOwnedNFT = balanceOf(_owner);
        uint256[] memory ownerIds = new uint256[](numberOfOwnedNFT);

        for(uint256 index = 0; index < numberOfOwnedNFT; index++){
            ownerIds[index] = tokenOfOwnerByIndex(_owner, index);
        }

        return ownerIds;
    }

    function setTokenUri(string memory _baseTokenUri) external onlyOwner{
        baseTokenUri = _baseTokenUri;
    }

    function setStep(uint _step) external onlyOwner {
            Currentstep = Step(_step);
        }

    function withdraw() external {
    uint256 balance = address(this).balance;
    require(balance > 0, "No funds to withdraw");
    address payable to = payable(withdrawalAddress);
    to.transfer(balance);
    }
}