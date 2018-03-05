pragma solidity ^0.4.20;

import "./ownable.sol";

contract Roulette is Ownable {
    uint maxPlayers = 2;
    address[2] players;

    uint8 nPlayers = 0;
    uint entryFee = 0.01 ether;
    uint randNonce = 0;
    uint afterHouseFee = 95;

    event NewPlayer(address player);

    function enterGame() external payable {
        require(msg.value >= entryFee);
        players[nPlayers] = msg.sender;
        nPlayers++;
        NewPlayer(msg.sender);
        if (nPlayers == maxPlayers) {
            _spinRevolver();
            _resetRevolver();
        }
    }

    function _spinRevolver() private {
        uint loser = _getRandom();
        uint prize = _getPrize();
        for (uint i = 0; i < maxPlayers; i++) {
            if (i != loser) {
                players[i].transfer(prize);
            }
        }
    }

    // TODO Improve this function
    function _getRandom() private returns(uint) {
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % maxPlayers;
    }

    function _getPrize() private view returns (uint) {
        return (entryFee * maxPlayers * afterHouseFee/100) / (maxPlayers - 1);
    }

    function _resetRevolver() private {
        nPlayers = 0;
    }

    function withdraw() external payable onlyOwner {
        require(nPlayers == 0);
        owner.transfer(this.balance);
    }

    function getCurrentPlayers() external view returns(address[2]) {
        return players;
    }
}