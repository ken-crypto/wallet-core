package com.trustwallet.core.app.blockchains.cro


import android.util.Log
import org.junit.Before
import org.junit.Test
import wallet.core.jni.AnyAddress
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet

class CroAddressTest {

    private val TAG = "CroAddressTest"
    private lateinit var hdWallet1: HDWallet
    private lateinit var hdWallet2: HDWallet
    private lateinit var hdWallet3: HDWallet


    init {
        System.loadLibrary("TrustWalletCore")
    }

    @Before
    fun setup() {
        hdWallet1 = HDWallet(
            "ripple scissors kick mammal hire column oak again sun offer wealth tomorrow wagon turn fatal",
            "TREZOR"
        )

        hdWallet2 = HDWallet(
            "pattern tape topple grow wreck column rude spoon vibrant walk shoe dad",
            ""
        )
        hdWallet3 = HDWallet(
            "shoot island position soft burden budget tooth cruel issue economy destroy above",
            ""
        )
    }

    @Test
    fun testAddress() {
        val privateKey1 = hdWallet1.getKey(CoinType.CRO, "m/44'/394'/0'/0/0")
        val publicKey1 = privateKey1.getPublicKeySecp256k1(true)
        val address1 = AnyAddress(publicKey1, CoinType.CRO).description()

        val privateKey2 = hdWallet2.getKey(CoinType.CRO, "m/44'/394'/0'/0/0")
        val publicKey2 = privateKey2.getPublicKeySecp256k1(true)
        val address2 = AnyAddress(publicKey2, CoinType.CRO).description()

        val privateKey3 = hdWallet3.getKey(CoinType.CRO, "m/44'/394'/0'/0/0")
        val publicKey3 = privateKey3.getPublicKeySecp256k1(true)
        val address3 = AnyAddress(publicKey3, CoinType.CRO).description()

        Assert.assertEquals(address1,"tcro1qhw03a43g23m9877czt6a0n0cmqyel6huxfkyy")
        Assert.assertEquals(address2,"tcro1dagn55m73kac8zm982tpycgptxf07yzh0jgqyp")
        Assert.assertEquals(address3,"tcro16fdf785ejm00jf9a24d23pzqzjh2h05k3nm2uk")
    }
}
