// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Week 1 最小合约：计数器
// 部署网络：Sepolia 测试网
// 合约地址：0x2CbDFd05C0c05260e0950Ed312476b65d7Fd0e8d
//
// 部署交易：
// https://sepolia.etherscan.io/tx/0x2abf89c26601a8a450ea3e484c3ee9488dc77185aaf051b5e69a2479e90e7bf1
//
// increment() 调用交易：
// https://sepolia.etherscan.io/tx/0xf7617b43ce5fc65f50b9e65120f0eb216a73b4eaef6e53449d1d96697b08551f

contract Counter {
    uint256 public count;

    // 写入函数：count + 1，需要 Gas + 钱包签名确认
    function increment() public {
        count += 1;
    }
}
