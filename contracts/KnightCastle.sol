pragma solidity ^0.4.24;

import "./SafeMath.sol";
//import "./Ownable.sol";

contract KnightCastle {
    
    struct Knight {
        string Name;
        uint8 Level;
        uint32 CurrentExp;
        uint32 ExpNeededForNextLevel;
        string Title;
        uint ReadyTime;
    }
    
    Knight[] knights;

    mapping (uint => address) public knightIndexToOwner;
    mapping (address => uint) ownerKnightCount;
    
    using SafeMath for uint;
    using SafeMath32 for uint8;
    
    uint32 expNeededForNextLevel = 50;
    
    event NewKnight(uint indexed knightId, string indexed name);

    constructor() internal {
        _createKnight("Genesis", 250);
        _createKnight("Another 1", 1);
        //owner = msg.sender;
    }
    
    function _createKnight(string _name, uint8 _level) internal {
        uint32 expGoal = (uint32(_level.mul(expNeededForNextLevel)));
        Knight memory knight = Knight({
            Name: _name,
            Level: _level,
            CurrentExp: 0,
            ExpNeededForNextLevel: expGoal,
            Title: "Adventurer",
            ReadyTime: now
        });
        uint id = knights.push(knight) - 1;
        knightIndexToOwner[id] = msg.sender;
        ownerKnightCount[msg.sender] = ownerKnightCount[msg.sender].add(1);
        emit NewKnight(id, _name);
    }
}