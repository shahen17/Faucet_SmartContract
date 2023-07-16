//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Faucet {
  address payable public owner;
  mapping(address => bool) public blacklistAddresses;
  mapping(address => uint256) public userTimeStamps;
  uint256 public timePeriod = 30 days; // time-period

  constructor() {
    owner = payable(msg.sender);
  }

  function addUserBlacklist(address _user) external {
    require(msg.sender == owner);
    blacklistAddresses[_user] = true;
  }

  function readUserBlacklist(address _user) internal view returns(bool) {
    return blacklistAddresses[_user];
  }
  
  function withdraw(uint _amount) public {
    // users can only withdraw .01 ETH at a time,
    require(_amount <= 10000000000000000);
    require(address(this).balance >= _amount);
    require(readUserBlacklist(msg.sender) == false);
    uint256 timeStamp = block.timestamp;
    uint256 lastTimeStamp = userTimeStamps[msg.sender];
    require(timeStamp >= lastTimeStamp + timePeriod);
    payable(msg.sender).transfer(_amount);
    userTimeStamps[msg.sender] == timeStamp;
    
  }

  function withdrawOwner(uint _amount) public {
    // only the owner can call this function,can withdraw full balance.
    require(msg.sender == owner);
    payable(msg.sender).transfer(_amount);
  }


  // fallback function
  receive() external payable {}
}