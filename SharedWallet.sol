// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract SharedWallet {
    using SafeMath for uint;
    address private owner;

    mapping(address => uint) public _owners;

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    modifier validOwner {
        require(msg.sender == owner || _owners[msg.sender]==1);
        _;
    }

    event DepositFunds(address from, uint amount);
    event WithdrawFunds(address from, uint amount);
    event TransferFunds(address from, address to, uint amount);

    constructor() {
        owner=msg.sender;
    }

    function addOwner(address _owner) public onlyOwner{
        _owners[_owner] = 1;
    }

    function removeOwner(address _owner) public onlyOwner{
        _owners[_owner] = 0;
    }

    function fund() public payable {
        emit DepositFunds(msg.sender,msg.value);
    }

    function withdraw(uint _amount) public validOwner payable{
        require(address(this).balance >=_amount);
        payable(msg.sender).transfer(_amount);
        emit WithdrawFunds(msg.sender,_amount);
    }

    function transferTo(address _to,uint _amount) public payable{
        require(address(this).balance >=_amount);
        payable(_to).transfer(_amount);
        emit TransferFunds(msg.sender,_to,_amount);
    }
}