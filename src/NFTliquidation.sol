// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {INonfungiblePositionManager} from "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import {IUniswapV3Pool} from "v3-core/interfaces/IUniswapV3Pool.sol";
import {PoolAddress} from "v3-periphery/libraries/PoolAddress.sol";

contract LPTracker {
    INonfungiblePositionManager public positionManager;

    constructor(address _positionManager) {
        positionManager = INonfungiblePositionManager(_positionManager);
    }

    function Position(uint128 TokenId)
        external
        view
        returns (
            int24,
            uint160,
            uint128,
            int24,
            int24,
            address,
            address
        )
    {
        (
            ,
            ,
            address token0,
            address token1,
            uint24 fee,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity,
            ,
            ,
            ,

        ) = positionManager.positions(TokenId);

        IUniswapV3Pool pool = IUniswapV3Pool(
            PoolAddress.computeAddress(
                positionManager.factory(),
                PoolAddress.PoolKey({token0: token0, token1: token1, fee: fee})
            )
        );

        (uint160 sqrtPriceX96, int24 tick, , , , , ) = pool.slot0();

        return (
            tick,
            sqrtPriceX96,
            liquidity,
            tickLower,
            tickUpper,
            token0,
            token1
        );
    }

    function wid(uint256 tokenId) external returns (bool) {
        uint256 amount0Min = type(uint256).max;
        uint256 amount1Min = type(uint256).max;
        uint256 deadline = block.number + 2;

        (, , , , , , , uint128 liquidity, , , , ) = positionManager.positions(
            tokenId
        );

        INonfungiblePositionManager.DecreaseLiquidityParams
            memory params = INonfungiblePositionManager
                .DecreaseLiquidityParams({
                    tokenId: tokenId,
                    liquidity: liquidity,
                    amount0Min: amount0Min,
                    amount1Min: amount1Min,
                    deadline: deadline
                });

        positionManager.decreaseLiquidity(params);

        return true;
    }
}