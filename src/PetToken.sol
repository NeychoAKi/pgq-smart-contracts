// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PetToken is ERC20("PetToken", "PET"), Ownable(msg.sender) {
    
    
    constructor(uint256 initialSupply) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
