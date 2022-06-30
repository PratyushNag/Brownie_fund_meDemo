//"SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public TotalAmtAddress;
    address[] fundersQ;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    function fund() public payable {
        uint256 minAmt = 50 * 10**18;
        require(getConversionRate(msg.value) >= minAmt, "Spend more ETH");
        TotalAmtAddress[msg.sender] += msg.value;
        fundersQ.push(msg.sender);
    }

    function getversion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethamount)
        public
        view
        returns (uint256)
    {
        uint256 ethprice = getPrice();
        uint256 EthUsd = (ethprice * ethamount) / 1000000000000000000;
        return EthUsd;
        //    0.000001568936907250
    }

    function getEntraceFee() public view returns (uint256) {
        //min USD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    modifier ownerpls() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable ownerpls {
        msg.sender.transfer(address(this).balance);
        for (uint256 i = 0; i < fundersQ.length; i++) {
            address funder = fundersQ[i];
            TotalAmtAddress[funder] = 0;
        }
        fundersQ = new address[](0);
    }
}
