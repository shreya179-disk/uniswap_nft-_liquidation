// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "src/tokens/ERC721.sol";

contract  UniswapV3_NFT is ERC721 {
    address public immutable factory;//once contract deployed it cannot be changed 
    constructor(address factoryAddress) 
        ERC721("Uniswap V3 NFT", "UNIV3"){
        factory = factoryAddress;
      }

    function tokenURL(uint256 tokenId) pubic view returns(string memory){
        return "";
    }

// minting has 2 operation : Add liquidity and minting a token 
    struct  TokenPosition {
        address pool;
        int24 lowerTick;
        int24 upperTick; 
    }
        
    mapping (uint256 => TokenPosition) public positions;

    function mintToken(//new tokens to mint
        address pool,
        uint256 tokenId,
        int24 upperTick,
        int24 lowerTick
    ) external{
        require(msg.sender == factory,"tokens can be mint only by factories");
        _mint(msg.sender,tokenId);
        position(tokenId) = TokenPosition({
            pool: pool,
            lowerTick: lowerTick,
            upperTick: upperTick
         });
    }    

    function updateTokenPosition(// function allows the owner of an NFT (the creator) to update the position associated with the NFT.
        address newPool,
        uint256 tokenId,
        int24 newLowerTick,
        int24 newUpperTick
    ) external{
        require(ownerOf(tokenId) == msg.sender,"this token is not owned by you");
        position[tokenId]=TokenPosition({
            pool: newPool,
            lowerTick: newLowerTick,
            upperTick: newUpperTick
    });
    }

    function getPosition(uint256 tokenId)external view returns(
        address pool,
        int24 lowerTick,
        int24 upperTick){
     TokenPosition storage position = positions[tokenId];
     return (position.pool, position.lowerTick, position.upperTick);
        }
}