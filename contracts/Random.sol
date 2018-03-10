pragma solidity ^0.4.19;

import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Random
 * @dev The Random provides a framework for Contracts that need to retrieve randomness.
 */
contract Random is Ownable {
    uint randNonce = 0;

    // TODO Improve this function
    function _getRandom(uint maxPlayers) internal returns(uint) {
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % maxPlayers;
    }
}