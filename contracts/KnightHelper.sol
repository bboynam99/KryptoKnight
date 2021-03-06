pragma solidity ^0.4.24;

import "./KnightCastle.sol";
import "./KnightTicket.sol";

contract KnightHelper is KnightCastle, KnightTicket {
    
    //event KnightNameChange(uint indexed knightId, string indexed newName);
    //event KnightTitleChange(uint indexed knightId, string indexed newTitle);
    //event TicketRefresh(uint _ticketId);

    modifier aboveLevel(uint _level, uint _knightId) {
        require(knights[_knightId].Level >= _level);
        _;
    }
    
    modifier onlyOwnerOf(uint _knightId) {
        require(msg.sender == knightIndexToOwner[_knightId]);
        _;
    }
    
    //knight level 2 or above can change Name
    function changeName(uint _knightId, string _newName) external onlyOwnerOf(_knightId) aboveLevel(2, _knightId)  {
        knights[_knightId].Name = _newName;
        //emit KnightNameChange(_knightId, _newName);
    }
    
    //knight level 10 or above can change Title
    function changeTitle(uint _knightId, string _newTitle) external onlyOwnerOf(_knightId) aboveLevel(10, _knightId) {
        knights[_knightId].Title = _newTitle;
        //emit KnightTitleChange(_knightId, _newTitle);
    }
    
    function refreshTicketUseLimit(uint _ticketId) external payable {
        require(tickets[_ticketId].UseLimit == 0);
        tickets[_ticketId].UseLimit = 5;
        //emit TicketRefresh(_ticketId);
    }
    
    function getKnightDetails(uint _index) public view returns(string, uint, uint, uint, string) {
        require(_index >= 0);
        require(_index < knights.length);        
        Knight storage knight = knights[_index];
        return (knight.Name, knight.Level, knight.CurrentExp, knight.ExpNeededForNextLevel, knight.Title);
    }

    //return array of uint of knightIndexToOwner
    function getKnightsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerKnightCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < knights.length; i++) {
            if (knightIndexToOwner[i] == _owner) {
                //knight is not in the market
                if (knights[i].isInMarket == false) {
                    result[counter] = i;
                    counter++;
                }
            }
        }
        return result;
    }

    function getTicketDetails(uint _index) public view returns(uint, uint, string) {
        require(_index >= 0);
        require(_index < tickets.length);
        Ticket storage ticket = tickets[_index];
        return (ticket.Gate, ticket.UseLimit, ticket.Description);
    }

    //return array of uint of ticketIndexToOwner
    function getTicketsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerTicketCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < tickets.length; i++) {
            if (ticketIndexToOwner[i] == _owner) {
                //ticket is not in the market
                if (tickets[i].isInMarket == false) {
                    if (tickets[i].UseLimit > 0) {
                        result[counter] = i;
                        counter++;
                    }
                }
            }
        }
        return result;
    }
}