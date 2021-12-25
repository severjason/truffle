// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
abstract contract MigrationAgent {
    function migrateFrom (address _from, uint256 _value) public virtual;
}