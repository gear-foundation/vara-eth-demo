// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IVaraEthDemo} from "./IVaraEthDemo.sol";
import {IVaraEthDemoCallbacks} from "./IVaraEthDemoCallbacks.sol";

contract VaraEthDemoCaller is IVaraEthDemoCallbacks {
    IVaraEthDemo public immutable VARA_ETH_PROGRAM;

    error UnauthorizedCaller();

    error UnknownMessage();

    constructor(IVaraEthDemo _varaEthProgram) {
        VARA_ETH_PROGRAM = _varaEthProgram;
    }

    modifier onlyVaraEthProgram() {
        _onlyVaraEthProgram();
        _;
    }

    function _onlyVaraEthProgram() internal view {
        if (msg.sender != address(VARA_ETH_PROGRAM)) {
            revert UnauthorizedCaller();
        }
    }

    /* Call `Counter` constructor on VARA.ETH */

    event Initialized();

    mapping(bytes32 messageId => bool knownMessage) public initInputs;

    function init(uint32 counter) external {
        /* `bool _callReply = true` */
        bytes32 messageId = VARA_ETH_PROGRAM.init(true, counter);
        initInputs[messageId] = true;
    }

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_init(bytes32 messageId) external onlyVaraEthProgram {
        bool knownMessage = initInputs[messageId];
        if (!knownMessage) {
            revert UnknownMessage();
        }
        emit Initialized();
    }

    /* Compute `Counter.add(uint32 value) -> uint32 reply` on VARA.ETH */

    mapping(bytes32 messageId => bool knownMessage) public counterAddInputs;
    mapping(bytes32 messageId => uint32 output) public counterAddResults;

    function counterAdd(uint32 value) external returns (bytes32 messageId) {
        /* `bool _callReply = true` */
        bytes32 _messageId = VARA_ETH_PROGRAM.counterAdd(true, value);
        counterAddInputs[_messageId] = true;
        messageId = _messageId;
    }

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_counterAdd(bytes32 messageId, uint32 reply) external onlyVaraEthProgram {
        bool knownMessage = counterAddInputs[messageId];
        if (!knownMessage) {
            revert UnknownMessage();
        }
        counterAddResults[messageId] = reply;
    }

    function getCounterAddResult(bytes32 messageId) public view returns (uint32) {
        return counterAddResults[messageId];
    }

    /* Compute `Counter.sub(uint32 value) -> uint32 reply` on VARA.ETH */

    mapping(bytes32 messageId => bool knownMessage) public counterSubInputs;
    mapping(bytes32 messageId => uint32 output) public counterSubResults;

    function counterSub(uint32 value) external returns (bytes32 messageId) {
        /* `bool _callReply = true` */
        bytes32 _messageId = VARA_ETH_PROGRAM.counterSub(true, value);
        counterSubInputs[_messageId] = true;
        messageId = _messageId;
    }

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_counterSub(bytes32 messageId, uint32 reply) external onlyVaraEthProgram {
        bool knownMessage = counterSubInputs[messageId];
        if (!knownMessage) {
            revert UnknownMessage();
        }
        counterSubResults[messageId] = reply;
    }

    function getCounterSubResult(bytes32 messageId) public view returns (uint32) {
        return counterSubResults[messageId];
    }

    /* Query `Counter.value() -> uint32 reply` on VARA.ETH */

    mapping(bytes32 messageId => bool knownMessage) public counterValueInputs;
    mapping(bytes32 messageId => uint32 output) public counterValueResults;

    function counterValue() external returns (bytes32 messageId) {
        /* `bool _callReply = true` */
        bytes32 _messageId = VARA_ETH_PROGRAM.counterValue(true);
        counterValueInputs[_messageId] = true;
        messageId = _messageId;
    }

    /// forge-lint: disable-next-line(mixed-case-function)
    function replyOn_counterValue(bytes32 messageId, uint32 reply) external onlyVaraEthProgram {
        bool knownMessage = counterValueInputs[messageId];
        if (!knownMessage) {
            revert UnknownMessage();
        }
        counterValueResults[messageId] = reply;
    }

    function getCounterValueResult(bytes32 messageId) public view returns (uint32) {
        return counterValueResults[messageId];
    }

    /* Handle `Counter` errors on VARA.ETH */

    event ErrorReply(bytes32 messageId, bytes payload, bytes4 replyCode);

    function onErrorReply(bytes32 messageId, bytes calldata payload, bytes4 replyCode)
        external
        payable
        onlyVaraEthProgram
    {
        emit ErrorReply(messageId, payload, replyCode);
    }
}
