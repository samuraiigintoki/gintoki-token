// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


contract ManualToken {

    mapping(address => uint256) private s_balances;
    mapping(address => mapping(address => uint256)) private s_allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor () public {
        s_balances[msg.sender] = 100 ether;
    }

    function name() public pure returns(string memory) {
        return "Gintoki Token";
    }


    function symbol() public pure returns(string memory) {
        return "GT";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint256) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }


    function transfer(address _to, uint256 _value) public {
        
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        
        require(s_balances[msg.sender] >= _value, "Insufficient Balance");
        require(msg.sender != address(0), "Must be a zero Address");
        require(_to != address(0),"Cannot transfer to zero Address.");

        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;

        require(previousBalances == s_balances[msg.sender] + s_balances[_to]);

        emit Transfer(msg.sender, _to, _value);

    }

    function transferFrom(address _from , address _to , uint256 _value) public {
        
        require(s_allowance[_from][msg.sender] >= _value, "Account Not Authorized");
        require(s_balances[_from] >= _value, "Insufficient Balance");
        require(msg.sender != address(0), "Must be a zero Address");       
        require(_to != address(0),"Cannot transfer to zero Address.");


        s_balances[_from] -= _value;
        s_balances[_to] += _value;
        s_allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
    
    } 

    function approve(address _spender, uint256 _value) public {
       s_allowance[msg.sender][_spender] = _value;
       emit Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return s_allowance[_owner][_spender];
    }

}