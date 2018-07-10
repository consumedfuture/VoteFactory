

const BigNumber = web3.BigNumber;
var ethUtil = require('ethereumjs-util')
var Tx = require('ethereumjs-tx');
const expect = require('chai').expect;
const should = require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(web3.BigNumber))
    .should();

import expectThrow from './helpers/expectThrow';


var VoteFactory = artifacts.require("./VoteFactory.sol");

contract('VoteFactory', function(accounts) {
    var voteFactory;

    const owner = accounts[0];
    const creator = accounts[1];
    const user = accounts[2];

    const question0 = "Question 0";
    const answer0 = "Answer 0";
    const answer1 = "Answer 1";

    beforeEach('setup contract for each test', async function () {
        voteFactory = await VoteFactory.new({from: owner});
    });

    it('vote created', async function () {
        await voteFactory.createVote(question0, {from: creator});
        var vote = await voteFactory.votes(0);
        
        vote.should.be.equal(question0);
    });

    it('answer added by creator', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await voteFactory.addAnswer(0, answer0, {from: creator});
    });

    it('answer added by user', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.addAnswer(0, answer0, {from: user}));
    });
    
    it('creates answer for not existing vote', async function () {
        await voteFactory.createVote(question0, {from: creator});
        await expectThrow(voteFactory.addAnswer(1, answer0, {from: creator}));
    });

    
});
