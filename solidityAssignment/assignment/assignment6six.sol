// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BinarySearch {
    /// @notice 在有序数组中查找目标值
    /// @param arr 升序数组
    /// @param target 要查找的目标值
    /// @return index 目标值所在索引，如果未找到返回 type(uint).max
    function search(uint[] memory arr, uint target) public pure returns (uint index) {
        uint left = 0; // 左边界
        uint right = arr.length; // 右边界（不包含）

        // 二分查找循环
        while (left < right) {
            uint mid = left + (right - left) / 2; // 防止溢出，计算中间索引
            if (arr[mid] == target) {
                return mid; // 找到目标值，返回索引
            } else if (arr[mid] < target) {
                left = mid + 1; // 目标值在右侧
            } else {
                right = mid; // 目标值在左侧
            }
        }

        // 未找到返回最大 uint 作为标识
        return type(uint).max;
    }
}
