from scripts.useful_scripts import get_account, LOCAL_BLOCKCHAIN_ENVIRONMENTS
from scripts.deploy import deploy_fundme
from brownie import network, accounts, exceptions
import pytest


def test_fund_and_withdraw():
    account = get_account()
    fund_me = deploy_fundme()
    entrance_fee = fund_me.getEntraceFee() + 100
    tx = fund_me.fund({"from": account, "value": entrance_fee})
    tx.wait(1)
    assert fund_me.TotalAmtAddress(account.address) == entrance_fee
    tx2 = fund_me.withdraw(
        {"from": account, "gas_limit": 6721975, "allow_revert": True}
    )
    tx2.wait(1)
    assert fund_me.TotalAmtAddress(account.address) == 0


def test_only_owner_can_withdraw():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("only for local testing")
        fund_me = deploy_fundme()
        bad_actor = accounts.add()
        with pytest.raises(exceptions.VirtualMachineError):
            fund_me.withdraw({"from": bad_actor})
