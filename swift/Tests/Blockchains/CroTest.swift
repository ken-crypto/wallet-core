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
        let fromAddress = AnyAddress(publicKey: publicKey, coin: .tcro)

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
               "mode":"sync",
               "tx":{
                   "fee":{
                       "amount":[
                           {
                               "amount":"20000",
                               "denom":"basetcro"
                           }
                       ],
                       "gas":"200000"
                   },
                   "memo":"",
                   "msg":[
                       {
                           "type":"cosmos-sdk/MsgSend",
                           "value":{
                               "amount":[
                                   {
                                       "amount":"100000000",
                                       "denom":"basetcro"
                                   }
                               ],
                               "from_address":"tcro1dagn55m73kac8zm982tpycgptxf07yzh0jgqyp",
                               "to_address":"tcro10ujdm7hxmc9c7xgnq8yqjn5flg3ycstzft2w4g"
                           }
                       }
                   ],
                   "signatures":[
                       {
                           "pub_key":{
                               "type":"tendermint/PubKeySecp256k1",
                               "value":"A2GE6AU3WFhaIgp+PB9vz5+jFhYJFljJsO+GVnwEkJUG"
                           },
                           "signature":"YmFi14spKHxXfuMKcOTJKOMi+QjJJdnpw1nPIXY2j3t1wH5hbfMd2RlTJUk9NBQ9qPNIp0XbBZIwO+GSD3tSSw=="
                       }
                   ]
               }
           }
        """

        XCTAssertJSONEqual(expectedJSON, output.json)
    }

    func testStaking() {
        let privateKey = PrivateKey(data: Data(hexString: "009165b5410ac341361a5795474e2ed954d2056745daf49794e4761e7cdf01c7")!)!
        let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
        let fromAddress = AnyAddress(publicKey: publicKey, coin: .tcro)

        let stakeMessage = CosmosMessage.Delegate.with {
            $0.delegatorAddress = fromAddress.description
            $0.validatorAddress = "tcrocncl1n4t5q77kn9vf73s7ljs96m85jgg49yqpg0chrj"
            $0.amount = CosmosAmount.with {
                $0.amount = 100000
                $0.denom = "basetcro"
            }
        }

        let message = CosmosMessage.with {
            $0.stakeMessage = stakeMessage
        }

        let fee = CosmosFee.with {
            $0.gas = 101721
            $0.amounts = [CosmosAmount.with {
                $0.amount = 1018
                $0.denom = "basetcro"
            }]
        }

        let input = CosmosSigningInput.with {
            $0.accountNumber = 1037
            $0.chainID = "testnet-croeseid-2"
            $0.memo = ""
            $0.sequence = 7
            $0.messages = [message]
            $0.fee = fee
            $0.privateKey = privateKey.data
        }

        let output: CosmosSigningOutput = AnySigner.sign(input: input, coin: .cosmos)

        let expectedJSON =
        """
            {
                "mode":"block",
                "tx":{
                    "fee":{
                        "amount":[
                            {
                                "amount":"1018",
                                "denom":"basetcro"
                            }
                        ],
                        "gas":"101721"
                    },
                    "memo":"",
                    "msg":[
                        {
                            "type":"cosmos-sdk/MsgDelegate",
                            "value":{
                                "amount":{
                                    "amount":"100000",
                                    "denom":"basetcro"
                                },
                                "delegator_address":"tcro1dagn55m73kac8zm982tpycgptxf07yzh0jgqyp",
                                "validator_address":"tcrocncl1n4t5q77kn9vf73s7ljs96m85jgg49yqpg0chrj"
                            }
                        }
                    ],
                    "signatures":[
                        {
                            "pub_key":{
                                "type":"tendermint/PubKeySecp256k1",
                                "value":"A2GE6AU3WFhaIgp+PB9vz5+jFhYJFljJsO+GVnwEkJUG"
                            },
                            "signature":"YROtMdlTyi4H05c8aJ0orvGg3g8FVQQWX68hUDrxEkg1UPGvQwJ/YuDtZAYwin97SRm5urjqWYGO/uUEJNiZTQ=="
                        }
                    ]
                }
            }
        """
        XCTAssertJSONEqual(expectedJSON, output.json)
    }

}

