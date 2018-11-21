pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract BCEOTokenInterface {
  function owner() public view returns (address);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool success);
}

contract BitCEOToken is StandardToken, BurnableToken, Ownable {
  string public constant name = "BitCEO";
  string public constant symbol = "BCEO";
  uint8 public constant decimals = 18;  
  uint256 public constant INITIAL_SUPPLY = 3500000000 * (10 ** uint256(decimals));

  constructor() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    
    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }

  function batchTransfer(address[] _receivers, uint256[] _amounts) public returns(bool) {
    uint256 cnt = _receivers.length;
    require(cnt > 0 && cnt <= 30);
    require(cnt == _amounts.length);

    cnt = (uint8)(cnt);

    uint256 totalAmount = 0;
    for (uint8 i = 0; i < cnt; i++) {
      totalAmount = totalAmount.add(_amounts[i]);
    }

    require(totalAmount <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(totalAmount);
    for (i = 0; i < cnt; i++) {
      balances[_receivers[i]] = balances[_receivers[i]].add(_amounts[i]);            
      emit Transfer(msg.sender, _receivers[i], _amounts[i]);
    }

    return true;
  }
  
}