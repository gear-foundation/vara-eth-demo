// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IVaraEthDemo {
    event Added(address indexed source, uint32 value);

    event Subtracted(address indexed source, uint32 value);

    function init(bool _callReply, uint32 counter) external returns (bytes32 messageId);

    function counterAdd(bool _callReply, uint32 value) external returns (bytes32 messageId);

    function counterSub(bool _callReply, uint32 value) external returns (bytes32 messageId);

    function counterValue(bool _callReply) external returns (bytes32 messageId);
}
