// SPDX-License-Identifier: UNLIMITED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 waveAddresses;

    // we will be using this below to help generate a random number
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    /* A struct is basically a custom datatype where we can customize
     what we want to hold inside it 
    */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // the message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    // variable that holds all the waves anyone ever sends to me

    Wave[] waves;

    /*
    * This is an address => unit mapping, meaning I can associate an address with a number!
    * In this case, I'll be storing the address with the last time the user waved at us.
    */
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Hello!!!, this is smart contract");
        // Set the initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    // the function requires a string called _message. this is the message our user
    // sends us from the frontend
    function wave(string memory _message) public {
        // There is need to make sure the current timestamp is at least 15-minutes bigger than the last 
        // timestamp we stored

        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        // update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        waveAddresses += 1;
        console.log("%s has waved!", msg.sender);

        // This is where I actually store the wave data in the array.
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        
        console.log("Random # generated: %d", seed);

        //Give a 50% chance that the user wins the prize.
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.00001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        // added some fanciness here
        emit NewWave(msg.sender, block.timestamp, _message);

    }

    // function getAllWaves returns the struct array, waves, to us.
    // This will make it easy to retrieve the waves from our website!

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getTotalAddresses() public view returns (uint256) {
        console.log("We have %d total waves addresses!", waveAddresses);
        return waveAddresses;
    }
}