// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RomanToInteger {
    /// @notice 将罗马数字转换为整数
    /// @param s 输入的罗马数字字符串
    /// @return result 转换后的整数值
    function romanToInt(string memory s) public pure returns (uint result) {
        bytes memory str = bytes(s); // 将字符串转换为字节数组，便于逐字符读取
        uint length = str.length;

        // 定义一个临时数组，用来存储每个字符对应的数值
        uint[] memory values = new uint[](length);

        // 遍历每个字符，映射成数值
        for (uint i = 0; i < length; i++) {
            bytes1 ch = str[i];

            if (ch == "I") values[i] = 1;
            else if (ch == "V") values[i] = 5;
            else if (ch == "X") values[i] = 10;
            else if (ch == "L") values[i] = 50;
            else if (ch == "C") values[i] = 100;
            else if (ch == "D") values[i] = 500;
            else if (ch == "M") values[i] = 1000;
            else revert("Invalid Roman numeral character"); // 非法字符保护
        }

        // 根据规则：如果当前值小于下一个值，则减去当前值，否则加上
        for (uint i = 0; i < length; i++) {
            if (i + 1 < length && values[i] < values[i + 1]) {
                result -= values[i];
            } else {
                result += values[i];
            }
        }
    }
}
