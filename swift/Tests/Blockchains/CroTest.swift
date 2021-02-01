//
//  CroTest.swift
//  WalletCoreTests
//
//  Created by weilong@crypto.com on 2021/1/31.
//

import XCTest
import WalletCore

class CroSignerTests: XCTestCase {

    let privateKey = PrivateKey(data: Data(hexString: "009165b5410ac341361a5795474e2ed954d2056745daf49794e4761e7cdf01c7")!)!

    func testSigningTransaction() {
        let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
        let fromAddress = AnyAddress(publicKey: publicKey, coin: .cro)

        let sendCoinsMessage = CosmosMessage.Send.with {
            $0.fromAddress = fromAddress.description
            $0.toAddress = "tcro10ujdm7hxmc9c7xgnq8yqjn5flg3ycstzft2w4g"
            $0.amounts = [CosmosAmount.with {
                $0.amount = 100000000
                $0.denom = "basetcro"
            }]
        }

        let message = CosmosMessage.with {
            $0.sendCoinsMessage = sendCoinsMessage
        }

        let fee = CosmosFee.with {
            $0.gas = 200000
            $0.amounts = [CosmosAmount.with {
                $0.amount = 20000
                $0.denom = "basetcro"
            }]
        }

        let input = CosmosSigningInput.with {
            $0.accountNumber = 1460
            $0.chainID = "testnet-croeseid-2"
            $0.memo = ""
            $0.sequence = 7
            $0.messages = [message]
            $0.fee = fee
            $0.privateKey = privateKey.data
            $0.mode = .sync
        }

        let output: CosmosSigningOutput = AnySigner.sign(input: input, coin: .cosmos)

        let expectedJSON: String =
"""
{
    "mode": "sync",
    "tx": {
        "fee": {
            "amount": [
                {
                    "amount": "20000",
                    "denom": "basetcro"
                }
            ],
            "gas": "200000"
        },
        "memo": "",
        "msg": [
            {
                "type": "cosmos-sdk/MsgSend",
                "value": {
                    "amount": [
                        {
                            "amount": "100000000",
                            "denom": "basetcro"
                        }
                    ],
                    "from_address": "tcro1dagn55m73kac8zm982tpycgptxf07yzh0jgqyp",
                    "to_address": "tcro10ujdm7hxmc9c7xgnq8yqjn5flg3ycstzft2w4g"
                }
            }
        ],
        "signatures": [
            {
                "pub_key": {
                    "type": "tendermint/PubKeySecp256k1",
                    "value": "A2GE6AU3WFhaIgp+PB9vz5+jFhYJFljJsO+GVnwEkJUG"
                },
                "signature": "YmFi14spKHxXfuMKcOTJKOMi+QjJJdnpw1nPIXY2j3t1wH5hbfMd2RlTJUk9NBQ9qPNIp0XbBZIwO+GSD3tSSw=="
            }
        ]
    }
}
"""

        XCTAssertJSONEqual(expectedJSON, output.json)
    }

    func testStaking() {
        let stakeMessage = CosmosMessage.Delegate.with {
            $0.delegatorAddress = "cosmos1hsk6jryyqjfhp5dhc55tc9jtckygx0eph6dd02"
            $0.validatorAddress = "cosmosvaloper1zkupr83hrzkn3up5elktzcq3tuft8nxsmwdqgp"
            $0.amount = CosmosAmount.with {
                $0.amount = 10
                $0.denom = "muon"
            }
        }

        let message = CosmosMessage.with {
            $0.stakeMessage = stakeMessage
        }

        let fee = CosmosFee.with {
            $0.gas = 101721
            $0.amounts = [CosmosAmount.with {
                $0.amount = 1018
                $0.denom = "muon"
            }]
        }

        let input = CosmosSigningInput.with {
            $0.accountNumber = 1037
            $0.chainID = "gaia-13003"
            $0.memo = ""
            $0.sequence = 7
            $0.messages = [message]
            $0.fee = fee
            $0.privateKey = privateKey.data
        }

        let output: CosmosSigningOutput = AnySigner.sign(input: input, coin: .cosmos)

        let expectedJSON = """
{
  "mode": "block",
  "tx": {
    "fee": {
      "amount": [
        {
          "amount": "1018",
          "denom": "muon"
        }
      ],
      "gas": "101721"
    },
    "memo": "",
    "msg": [
      {
        "type": "cosmos-sdk/MsgDelegate",
        "value": {
          "amount": {
            "amount": "10",
            "denom": "muon"
          },
          "delegator_address": "cosmos1hsk6jryyqjfhp5dhc55tc9jtckygx0eph6dd02",
          "validator_address": "cosmosvaloper1zkupr83hrzkn3up5elktzcq3tuft8nxsmwdqgp"
        }
      }
    ],
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AlcobsPzfTNVe7uqAAsndErJAjqplnyudaGB0f+R+p3F"
        },
        "signature": "wIvfbCsLRCjzeXXoXTKfHLGXRbAAmUp0O134HVfVc6pfdVNJvvzISMHRUHgYcjsSiFlLyR32heia/yLgMDtIYQ=="
      }
    ]
  }
}

"""
        XCTAssertJSONEqual(expectedJSON, output.json)
    }

    func testWithdraw() {
        // https://stargate.cosmos.network/txs/DE2FF0BC39E70DB576DF86C263A5BDB42FF3D5D5B914A4A30E8C13B14A950FFF
        let delegator = "cosmos100rhxclqasy6vnrcervgh99alx5xw7lkfp4u54"
        let validators = [
            "cosmosvaloper1ey69r37gfxvxg62sh4r0ktpuc46pzjrm873ae8",
            "cosmosvaloper1sjllsnramtg3ewxqwwrwjxfgc4n4ef9u2lcnj0",
            "cosmosvaloper1648ynlpdw7fqa2axt0w2yp3fk542junl7rsvq6"
        ]

        let withdrawals = validators.map { validator in
            CosmosMessage.WithdrawDelegationReward.with {
                $0.delegatorAddress = delegator
                $0.validatorAddress = validator
            }
        }.map { withdraw in
            CosmosMessage.with {
                $0.withdrawStakeRewardMessage = withdraw
            }
        }

        let fee = CosmosFee.with {
            $0.amounts = [CosmosAmount.with {
                $0.denom = "uatom"
                $0.amount = 1
            }]
            $0.gas = 220000
        }

        let input = CosmosSigningInput.with {
            $0.fee = fee
            $0.accountNumber = 8698
            $0.chainID = "cosmoshub-2"
            $0.sequence = 318
            $0.messages = withdrawals
            $0.fee = fee
            $0.privateKey = privateKey.data
        }

        let output: CosmosSigningOutput = AnySigner.sign(input: input, coin: .cosmos)

        let expectedJSON = """
        {
          "mode": "block",
          "tx": {
            "fee": {
              "amount": [
                {
                  "amount": "1",
                  "denom": "uatom"
                }
              ],
              "gas": "220000"
            },
            "memo": "",
            "msg": [
              {
                "type": "cosmos-sdk/MsgWithdrawDelegationReward",
                "value": {
                  "delegator_address": "cosmos100rhxclqasy6vnrcervgh99alx5xw7lkfp4u54",
                  "validator_address": "cosmosvaloper1ey69r37gfxvxg62sh4r0ktpuc46pzjrm873ae8"
                }
              },{
                "type": "cosmos-sdk/MsgWithdrawDelegationReward",
                "value": {
                  "delegator_address": "cosmos100rhxclqasy6vnrcervgh99alx5xw7lkfp4u54",
                  "validator_address": "cosmosvaloper1sjllsnramtg3ewxqwwrwjxfgc4n4ef9u2lcnj0"
                }
              },{
                "type": "cosmos-sdk/MsgWithdrawDelegationReward",
                "value": {
                  "delegator_address": "cosmos100rhxclqasy6vnrcervgh99alx5xw7lkfp4u54",
                  "validator_address": "cosmosvaloper1648ynlpdw7fqa2axt0w2yp3fk542junl7rsvq6"
                }
              }
            ],
            "signatures": [
              {
                "pub_key": {
                  "type": "tendermint/PubKeySecp256k1",
                  "value": "AlcobsPzfTNVe7uqAAsndErJAjqplnyudaGB0f+R+p3F"
                },
                "signature": "2k5bSnfWxaauXHBNJTKmf4CpLiCWLg7UAC/q2SVhZNkU+n0DdLBSTdmYhKYmmtpl/Njm4YrcxE0WLb/hVccQ+g=="
              }
            ]
          }
        }

        """
        XCTAssertJSONEqual(expectedJSON, output.json)
    }
}

