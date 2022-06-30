from brownie import FundMe
from scripts.useful_scripts import get_account


def fund():
    fund_me = FundMe[-1]
    account = get_account()
    entrance_fee = fund_me.getEntraceFee()
    print(f"entrance_fee is {entrance_fee}")
    print("funding..")
    fund_me.fund({"from": account, "value": entrance_fee})


def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account, "gas_limit": 6721975})


def main():
    fund()
    withdraw()
