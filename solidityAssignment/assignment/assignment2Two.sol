// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
反转字符串 (Reverse String)
题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"
*/
contract ReverseString {
    // 函数：反转输入的字符串
    function reverse(string memory input) public pure returns (string memory) {
        bytes memory strBytes = bytes(input);  // 将字符串转换为字节数组
        uint length = strBytes.length;         // 获取字符串长度
        bytes memory reversed = new bytes(length); // 创建一个新的字节数组用于存储反转结果

        // 使用循环，从后往前取字符
        for (uint i = 0; i < length; i++) {
            reversed[i] = strBytes[length - 1 - i]; // 将原字符串末尾的字符依次放到新数组前面
        }

        // 将字节数组重新转换为字符串并返回
        return string(reversed);
    }
}
