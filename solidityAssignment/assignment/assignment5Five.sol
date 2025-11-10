// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeSortedArray {
    /// @notice 合并两个升序数组为一个新的升序数组
    /// @param arr1 第一个有序数组
    /// @param arr2 第二个有序数组
    /// @return merged 合并后的新数组（升序）
    function merge(uint[] memory arr1, uint[] memory arr2) public pure returns (uint[] memory merged) {
        uint len1 = arr1.length; // 第一个数组长度
        uint len2 = arr2.length; // 第二个数组长度
        uint i = 0; // arr1 的索引
        uint j = 0; // arr2 的索引
        uint k = 0; // merged 的索引

        // 初始化合并后数组，长度 = arr1 + arr2 的长度
        merged = new uint[](len1 + len2);

        // 当两个数组都未遍历完时，逐一比较取最小的放入 merged
        while (i < len1 && j < len2) {
            if (arr1[i] <= arr2[j]) {
                merged[k] = arr1[i];
                i++;
            } else {
                merged[k] = arr2[j];
                j++;
            }
            k++;
        }

        // 如果 arr1 还有剩余，直接复制
        while (i < len1) {
            merged[k] = arr1[i];
            i++;
            k++;
        }

        // 如果 arr2 还有剩余，直接复制
        while (j < len2) {
            merged[k] = arr2[j];
            j++;
            k++;
        }

        return merged;
    }
}
