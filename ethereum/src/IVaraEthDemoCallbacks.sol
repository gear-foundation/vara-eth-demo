// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IVaraEthDemoCallbacks {
    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_init(bytes32 messageId) external;

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_counterAdd(bytes32 messageId, uint32 reply) external;

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_counterSub(bytes32 messageId, uint32 reply) external;

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_counterValue(bytes32 messageId, uint32 reply) external;

    function onErrorReply(bytes32 messageId, bytes calldata payload, bytes4 replyCode) external payable;
}
