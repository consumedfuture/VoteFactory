pragma solidity ^0.4.24;

import "./Ownable.sol";

contract VoteFactory is Ownable {

    enum State {
        Initial, 
        Started, 
        Stopped
    }

    struct Vote {
        string question;
        string[] answers;
        State state;
    }
    
    Vote[] public votes;
    mapping (uint => address) voteToOwner;
    
    modifier onlyVoteOwner(uint _voteId) {
        require(voteToOwner[_voteId] == msg.sender);
        _;
    }    

    modifier voteStateIsInitial(uint _voteId) {
        require(votes[_voteId].state == State.Initial);
        _;
    }

    modifier voteStateIsStarted(uint _voteId) {
        require(votes[_voteId].state == State.Started);
        _;
    }

    modifier voteStateIsStopped(uint _voteId) {
        require(votes[_voteId].state == State.Stopped);
        _;
    }

    modifier voteStateIsInitialOrStopped(uint _voteId) {
        require((votes[_voteId].state == State.Initial) || (votes[_voteId].state == State.Stopped));
        _;
    }
    
    function createVote(string _question) public {
        uint VoteId = votes.push(Vote(_question, new string[](0), State.Initial)) - 1;
        voteToOwner[VoteId] = msg.sender;
    }
    
    function addAnswer(uint _voteId, string _answer) onlyVoteOwner(_voteId) voteStateIsInitial(_voteId) public {
        votes[_voteId].answers.push(_answer);
    }

    function startVote(uint _voteId) onlyVoteOwner(_voteId) voteStateIsInitialOrStopped(_voteId) public {
        votes[_voteId].state = State.Started;
    }

    function stopVote(uint _voteId) onlyVoteOwner(_voteId) voteStateIsStopped(_voteId) public {
        votes[_voteId].state = State.Stopped;
    }
}