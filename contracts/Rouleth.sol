pragma solidity ^0.4.19;

import "./Random.sol";

/**
 * @title Rouleth
 * @dev The Rouleth contract allows 6 players to play Russian Roulette.
 */
contract Rouleth is Random {
    uint public maxPlayers = 6;
    address[6] players;
    uint8 public nPlayers = 0;
    uint public entryFee = 0.01 ether;
    uint public afterHouseFee = 95;
    uint public deathCounter = 0;
    address[] deadPlayers;

    event NewPlayer(address player);
    event GameFinished(address[6] players, uint loser);

    modifier playOnlyOnce() {
      /*  for (uint i = 0; i < maxPlayers; i++) {
            require(msg.sender != players[i]);
        }*/
        _;
    }

    modifier notDead() {
       /* for (uint i = 0; i < deathCounter; i++) {
            require(msg.sender != deadPlayers[i]);
        }*/
        _;
    }

    function getPlayers() external view returns(address[6]) {
        return players;
    }

    function getDeadPlayers() external view returns(address[]) {
        return deadPlayers;
    }

    function enterGame() external payable playOnlyOnce notDead {
        require(msg.value >= entryFee);
        players[nPlayers] = msg.sender;
        nPlayers++;
        NewPlayer(msg.sender);
        if (nPlayers == maxPlayers) {
            uint _loser = _spinRevolver();
            GameFinished(players, _loser);
            _resetRevolver();
        }
    }

    function _spinRevolver() private returns(uint) {
        uint _loser = _getRandom(maxPlayers);
        uint _prize = _getPrize();
        for (uint i = 0; i < maxPlayers; i++) {
            if (i != _loser) {
                players[i].transfer(_prize);
            } else {
                _addToTheDead(i);
            }
        }
        return _loser;
    }

    function _addToTheDead(uint _index) private {
        deadPlayers.push(players[_index]);
        deathCounter++;
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
}