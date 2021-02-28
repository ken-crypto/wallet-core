package com.trustwallet.core.app.blockchains.cro


import android.util.Log
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import wallet.core.jni.AnyAddress
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet

class TCroAddressTest {

    private val TAG = "TCroAddressTest"
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
        val privateKey1 = hdWallet1.getKey(CoinType.TCRO, "m/44'/1'/0'/0/0")
        val publicKey1 = privateKey1.getPublicKeySecp256k1(true)
        val address1 = AnyAddress(publicKey1, CoinType.TCRO).description()

        val privateKey2 = hdWallet2.getKey(CoinType.TCRO, "m/44'/1'/0'/0/0")
        val publicKey2 = privateKey2.getPublicKeySecp256k1(true)
        val address2 = AnyAddress(publicKey2, CoinType.TCRO).description()

        val privateKey3 = hdWallet3.getKey(CoinType.TCRO, "m/44'/1'/0'/0/0")
        val publicKey3 = privateKey3.getPublicKeySecp256k1(true)
        val address3 = AnyAddress(publicKey3, CoinType.TCRO).description()
        Log.i(TAG,address1)
        Log.i(TAG,address2)
        Log.i(TAG,address3)

        Assert.assertEquals(address1, "tcro1fpk0hwpuzdqsjg05rlt72vnrh2598h5q5uzzws")
        Assert.assertEquals(address2, "tcro10ujdm7hxmc9c7xgnq8yqjn5flg3ycstzft2w4g")
        Assert.assertEquals(address3, "tcro1z9hasaumxlgf3mkd27xa9yyhuum5g5xytrp3fz")
    }
}
