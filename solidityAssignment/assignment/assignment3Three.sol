// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IntegerToRoman {
    /// @notice 将整数转换为罗马数字字符串
    /// @param num 输入的整数（1 ≤ num ≤ 3999）
    /// @return result 对应的罗马数字字符串
    function intToRoman(uint num) public pure returns (string memory result) {
        require(num >= 1 && num <= 3999, "Number out of range (1-3999)");

        // 定义罗马数字符号（从大到小排列）
        string[13] memory symbols = [
            "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"
        ];

        // 显式声明每个数值为 uint（防止类型推断错误）
        uint[13] memory values = [
            uint(1000), uint(900), uint(500), uint(400),
            uint(100), uint(90), uint(50), uint(40),
            uint(10), uint(9), uint(5), uint(4), uint(1)
        ];

        // 用 bytes 形式拼接字符串，效率更高
        bytes memory res;

        // 从大到小依次匹配
        for (uint i = 0; i < 13; i++) {
            // 当 num 大于等于当前值时，减去并拼接对应符号
            while (num >= values[i]) {
                num -= values[i]; // 减去当前数值
                res = abi.encodePacked(res, symbols[i]); // 拼接对应符号
            }
        }

        // 返回最终结果
        return string(res);
    }
}
