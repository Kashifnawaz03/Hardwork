// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract myDemoToken is ERC20 {
    using SafeMath for uint;
    uint public cap;
    uint MaxCap = 10;
    address admin;
    uint256 public totalWhitelisted = 0;
    uint public whitelisted;
    address public owner;
    uint presalestart = 1648101068;  //24/03/2022
    uint presalesend = 1650779468;   //24/04/2022
    mapping(address => uint) private accounts;
    mapping (address => bool) public whitelist;

    event AddressWhitelisted(address user, bool whitelisted);

    constructor() ERC20("myDemoToken","MDT"){
        owner = msg.sender;
        uint initialSupply  = 10000 * (10** uint(decimals()));
        cap = initialSupply.mul(2);
        _mint(msg.sender,initialSupply);    
    }

    function whiteList() public {
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
       
   function buyPreSale(uint amount)public payable{
       
        require(msg.value <= MaxCap, "You have exceed the Max cap limit");
        require(block.timestamp > presalestart, "You have to wait");
        require(block.timestamp > presalesend, "Pre_sale has finished");
        accounts[msg.sender] = msg.value;
        accounts[msg.sender] *=5;
        payable(msg.sender).transfer(amount);
   }
   function buyAfterPreSale(uint amount)public payable{
        require(accounts[msg.sender] == 0, "Account already exist");
        require(msg.value > 0 && msg.sender != address(0), "Value should not be 0 or Invalid address");
        require(block.timestamp > presalesend, "You have to wait");  
        accounts[msg.sender] = msg.value;
        accounts[msg.sender] *=2;
        payable(msg.sender).transfer(amount);
   }
   function InquireBalance()public view returns(uint){
        return accounts[msg.sender];
    }
}