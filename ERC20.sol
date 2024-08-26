// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    address private organizer;
    uint256 private totalDonations;

    mapping(address => uint256) private donations;

    modifier onlyOrganizer() {
        require(
            msg.sender == organizer,
            "Only the organizer can perform this action"
        );
        _;
    }

    constructor(uint256 initialSupply) ERC20("FundraiserToken", "FRT") {
        _mint(msg.sender, initialSupply);
        organizer = msg.sender;
    }

    function mintTokens(uint256 amount) external onlyOrganizer {
        require(amount > 0, "Mint amount must be greater than zero");
        _mint(organizer, amount);
    }

    function donateTokens(address to, uint256 amount) public {
        require(to != address(0), "Cannot donate to the zero address");
        require(amount > 0, "Donation amount must be greater than zero");
        require(
            balanceOf(msg.sender) >= amount,
            "Insufficient balance to donate"
        );

        _transfer(msg.sender, to, amount);
        donations[msg.sender] += amount;
        totalDonations += amount;
    }

    function burnTokens(uint256 amount) public {
        require(amount > 0, "Burn amount must be greater than zero");
        require(
            balanceOf(msg.sender) >= amount,
            "Insufficient balance to burn"
        );

        _burn(msg.sender, amount);
    }

    function checkDonationHistory() public view returns (uint256) {
        return donations[msg.sender];
    }

    function viewTotalDonations() public view onlyOrganizer returns (uint256) {
        return totalDonations;
    }
}
