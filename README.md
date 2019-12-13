## Build dependencies for `Bitcoin TestNet` 

### Prerequisites

* CMake brew install cmake
* Boost brew install boost
* Xcode
* Xcode command line tools: xcode-select --install
* Other tools: brew install git ninja autoconf automake libtool
* xcodegen clang-format
* Cocoapods for iOS: sudo gem install cocoapods
* Android Studio
* Android NDK

### Add coin definition into `coin.json` 
```
    {
        "id": "bitcoinTest",
        "name": "BitcoinTest",
        "symbol": "BTCTest",
        "decimals": 8,
        "blockchain": "Bitcoin",
        "derivationPath": "m/84'/1'/0'/0/0",
        "curve": "secp256k1",
        "publicKeyType": "secp256k1",
        "p2pkhPrefix": 111,
        "p2shPrefix": 196,
        "hrp": "tb",
        "publicKeyHasher": "sha256ripemd",
        "base58Hasher": "sha256d",
        "xpub": "zpub",
        "xprv": "zprv",
        "explorer": {
            "url": "https://blockchair.com",
            "txPath": "/bitcoin/transaction/",
            "accountPath": "/bitcoin/address/",
            "sampleTx": "0607f62530b68cfcc91c57a1702841dd399a899d0eecda8e31ecca3f52f01df2",
            "sampleAccount": "17A16QmavnUfCW11DAApiJxp7ARnxN5pGX"
        }, 
        "info": {
          "url": "https://bitcoin.org",
          "client": "https://github.com/trezor/blockbook",
          "clientPublic": "",
          "clientDocs": "https://github.com/trezor/blockbook/blob/master/docs/api.md"
        }
      },

```

### Downloads and compiles some prerequisites.
```
./tools/install-dependencies

```

### generates source files
```
./tools/generate-files

```
### Add `BitCoinTest` type info `Coin.cpp`、`Coins.cpp`、`TWCoinType.h`

### Build `C/C++` layer 
```
cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Debug
make -Cbuild tests TrezorCryptoTests
```
### Add `BitCoinTest` type info `CoinType.java` and `CoinType.swift`

### Release dependence

* For Android  
```
./gradlew assembleRelease
cp trustwalletcore/build/outputs/aar/trustwalletcore-release.aar ../build/trustwalletcore.aar
```
* For Ios





