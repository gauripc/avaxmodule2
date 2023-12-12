// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ExampleContract {
    uint public value1;
    string public value2;

    function setValue1(uint _newValue) public {
        value1 = _newValue;
    }

    function setValue2(string memory _newValue) public {
        value2 = _newValue;
    }
}
