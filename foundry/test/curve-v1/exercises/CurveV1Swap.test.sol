// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {IStableSwap3Pool} from "../../../src/interfaces/curve/IStableSwap3Pool.sol";
import {IERC20} from "../../../src/interfaces/IERC20.sol";
import {DAI, USDC, USDT, CURVE_3POOL} from "../../../src/Constants.sol";

contract CurveV1SwapTest is Test {
    IStableSwap3Pool private constant pool = IStableSwap3Pool(CURVE_3POOL);
    IERC20 private constant dai = IERC20(DAI);
    IERC20 private constant usdc = IERC20(USDC);
    IERC20 private constant usdt = IERC20(USDT);

    function setUp() public {
        deal(DAI, address(this), 1e6 * 1e18);
        dai.approve(address(pool), type(uint256).max);
    }

    // Exercise 1
    // Call get_dy_underlying to calculate the amount of USDC for swapping
    // 1,000,000 DAI to USDC
    function test_get_dy_underlying() public {
        // Calculate swap from DAI to USDC
        // Write your code here
        uint256 dy = 0;
        int128 i = 0; // DAI index
        int128 j = 1; // USDC index
        uint256 dx = 1e6 * 1e18; // 1,000,000 DAI in wei

        dy = pool.get_dy_underlying(i, j, dx);

        console2.log("dy %e", dy);
        assertGt(dy, 0, "dy = 0");
    }

    // Exercise 2
    // Call exchange to swap 1,000,000 DAI to USDC
    function test_exchange() public {
        // Swap DAI to USDC
        // Write your code here
        // function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy)
        int128 i = 0; // DAI index
        int128 j = 1; // USDC index
        uint256 dx = 1e6 * 1e18; // 1,000,000 DAI in wei
        uint256 min_dy = pool.get_dy_underlying(i, j, dx);

        pool.exchange(i, j, dx, min_dy);

        uint256 bal = usdc.balanceOf(address(this));
        console2.log("USDC balance %e", bal);
        assertGt(bal, 0, "USDC balance = 0");
    }
}
