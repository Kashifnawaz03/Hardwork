// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract AddWhitelist {

  address admin;

  mapping (address => bool) public whitelist;
  uint256 public totalWhitelisted = 0;
  uint public whitelisted;
  

  event AddressWhitelisted(address user, bool whitelisted);

  function Whitelist() public {
    admin = msg.sender;
  }
  function whitelistAddress(address[] memory _users , bool _whitelisted) public {
    require(msg.sender == admin);
    for (uint i = 0; i < _users.length; i++) {
      if (whitelist[_users[i]] == _whitelisted) continue;
      if (_whitelisted) {
        totalWhitelisted++;
      } else {
        if (totalWhitelisted > 0) {
          totalWhitelisted--;
        }
      }
       emit AddressWhitelisted(_users[i], _whitelisted);
      whitelist[_users[i]] = _whitelisted;
    }
  }
}

 
contract myDemoToken is ERC20, AddWhitelist {
    using SafeMath for uint;
    uint public cap;
    uint MaxCap = 10;
    
    
    address public owner;
    mapping(address => uint) private accounts;
    constructor() ERC20("myDemoToken","MDT")public{
        owner = msg.sender;
        uint initialSupply  = 10000 * (10** uint(decimals()));
        cap = initialSupply.mul(2);
       
        _mint(msg.sender,initialSupply);
    }
    
    function adjustPrice(uint amount) public view {
        require(msg.sender == owner, "Only owner can adjust the price");
    }
    
   function buyPreSale()public payable{
        require(accounts[msg.sender] == 0, "Account already exist");
        require(msg.value > 0 && msg.sender != address(0), "Value should not be 0 or Invalid address");
        //require(msg.sender === whitelisted, "You are not approved for Presale");
        require(msg.value >= MaxCap, "You have exceed the Max cap limit");
        require(block.timestamp <= (30 days), "You have to wait");
        require(block.timestamp >= (40 days), "You have to wait");
        accounts[msg.sender] = msg.value;
        accounts[msg.sender] *=5;
        
   }
   function buyAfterPreSale()public payable{
        require(accounts[msg.sender] == 0, "Account already exist");
        require(msg.value > 0 && msg.sender != address(0), "Value should not be 0 or Invalid address");
        
        accounts[msg.sender] = msg.value;
        accounts[msg.sender] *=2;
        
   }
}