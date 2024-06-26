// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TokenMaster is ERC721 {
    address public owner;
    uint256 public totalOccasions;
    uint256 public totalSupply;

    struct Occasion {
        uint256 id;
        string name;
        uint256 cost;
        uint256 tickets;
        uint256 maxTickets;
        string date;
        string time;
        string location;
    }

    mapping(uint256 => Occasion) public occasions;
    mapping(uint256 => mapping(address => bool)) public hasBought;
    mapping(uint256 => mapping(uint256 => address)) public seatTaken;
    mapping(uint256 => uint256[]) public seatsTaken;

    event OccasionListed(uint256 id, string name, uint256 cost, uint256 maxTickets, string date, string time, string location);
    event TicketMinted(uint256 occasionId, uint256 seat, address buyer);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        owner = msg.sender;
    }

    function list(
        string memory _name,
        uint256 _cost,
        uint256 _maxTickets,
        string memory _date,
        string memory _time,
        string memory _location
    ) public onlyOwner {
        require(_maxTickets > 0, "Max tickets must be greater than zero");
        totalOccasions++;
        occasions[totalOccasions] = Occasion(
            totalOccasions,
            _name,
            _cost,
            _maxTickets,
            _maxTickets,
            _date,
            _time,
            _location
        );
        emit OccasionListed(totalOccasions, _name, _cost, _maxTickets, _date, _time, _location);
    }

    function mint(uint256 _id, uint256 _seat) public payable {
        require(_id > 0 && _id <= totalOccasions, "Invalid occasion ID");
        require(msg.value >= occasions[_id].cost, "Insufficient payment");
        require(occasions[_id].tickets > 0, "No tickets available");
        require(seatTaken[_id][_seat] == address(0), "Seat already taken");

        occasions[_id].tickets -= 1;

        hasBought[_id][msg.sender] = true;
        seatTaken[_id][_seat] = msg.sender;
        seatsTaken[_id].push(_seat);

        totalSupply++;
        _safeMint(msg.sender, totalSupply);

        emit TicketMinted(_id, _seat, msg.sender);
    }

    function getOccasion(uint256 _id) public view returns (Occasion memory) {
        require(_id > 0 && _id <= totalOccasions, "Invalid occasion ID");
        return occasions[_id];
    }

    function getSeatTaken(uint256 _id) public view returns (uint256[] memory) {
        require(_id > 0 && _id <= totalOccasions, "Invalid occasion ID");
        return seatsTaken[_id];
    }

    function withdraw() public onlyOwner {
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success);
    }
}
