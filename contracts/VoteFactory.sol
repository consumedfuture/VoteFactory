pragma solidity ^0.4.19;

contract VoteFactory {
    
    address owner;

    struct Vote {
        string question;
        string[] answers;
    }
    
    Vote[] public votes;
    mapping (uint => address) voteToOwner;
    
    constructor () public {
        owner = msg.sender;
    }
    
    modifier onlyVoteOwner(uint _voteId) {
        require(voteToOwner[_voteId] == msg.sender);
        _;
    }    
    
    function createVote(string _question) public {
        uint VoteId = votes.push(Vote(_question, new string[](0))) - 1;
        voteToOwner[VoteId] = msg.sender;
    }
    
    function addAnswer(uint _voteId, string _answer) onlyVoteOwner(_voteId) public {
        votes[_voteId].answers.push(_answer);
    }
}