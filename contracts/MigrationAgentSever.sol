// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "./AwesomeTokenNew.sol";
import "./Owned.sol";
import "./SeverToken.sol";


contract MigrationAgentSever is Owned {
    address sourceToken;
    address targetToken;
    uint256 tokenSupply;

    constructor (address _sourceToken) {
        sourceToken = _sourceToken;
        tokenSupply = AwesomeTokenNew(sourceToken).totalSupply();
    }

    function setTargetToken(address _targetToken) public onlyOwner {
        require(targetToken == address(0), "Target token can not be changed");
        targetToken = _targetToken;
    }

    function safetyInvariantCheck(uint256 _value) private view {
        require(targetToken != address(0), 'Target token are not set');
        require(AwesomeTokenNew(sourceToken).totalSupply() + SeverToken(targetToken).totalSupply() == tokenSupply - _value);
    }

    function migrateFrom (address _from, uint256 _value) public {
        require(msg.sender == sourceToken, 'You can migrate only from source token');
        require(targetToken != address(0), 'Target token is not set');
        safetyInvariantCheck(_value);
        SeverToken(targetToken).createToken(_from, _value);
        safetyInvariantCheck(0);
    }

    function finalizeMigration() public onlyOwner  {
        safetyInvariantCheck(0);
        AwesomeTokenNew(sourceToken).finalizeMigration();
        SeverToken(targetToken).finalizeMigration();
        sourceToken = address(0);
        targetToken = address(0);
        tokenSupply = 0;
    }
}