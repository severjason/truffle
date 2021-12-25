// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "./Owned.sol";
import "./MigrationAgent.sol";

contract SeverToken is Owned {
    string public name;
    string public symbol;
    uint256 public totalSupply = 0;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    MigrationAgent public migrationAgent;
    uint256 public totalMigrated;
    bool public isMigrationStarted;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Migrate(address indexed _from, address indexed _to, uint256 _value);

    constructor(string memory tokenName, string memory tokenSymbol) {
        name = tokenName;
        symbol = tokenSymbol;
    }

    function _transfer(address _from, address _to, uint _value ) internal {
        require(isMigrationStarted == false, "Migration already started");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function setMigrationAgent(address _agent) external onlyOwner {
        require(address(migrationAgent) == address(0), "Migration can`t be changed");
        migrationAgent = MigrationAgent(_agent);
        isMigrationStarted = true;
    }

    function migrate(uint256 _value) external {
        require(isMigrationStarted, "Migration is not started");
        require(_value != 0, "You have no tokens");
        require(_value <= balanceOf[msg.sender], "You have not enough tokens");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        totalMigrated += _value;
        migrationAgent.migrateFrom(msg.sender, _value);
        emit Migrate(msg.sender, address(migrationAgent), _value);
    }

    function createToken(address _target, uint256 _amount) public {
        require(msg.sender == address(migrationAgent), 'You can create token only from Migration agent');
        balanceOf[_target] += _amount;
        totalSupply += _amount;
        emit Transfer(address(migrationAgent), _target, _amount);
    }

    function finalizeMigration() public {
        require(msg.sender == address(migrationAgent), 'Only Migration Agent can finalize migration');
        isMigrationStarted = false;
        migrationAgent = MigrationAgent(address(0));
    }

}   