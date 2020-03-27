// Copyright © 2017-2020 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#pragma once

#include <string>

#include "../Base58Address.h"
#include "../Data.h"
#include "../PublicKey.h"

namespace TW::NEO {

static const unsigned AddressSize{21};

class Address : public TW::Base58Address<AddressSize> {
  public:
    /// NEO address version is 23
    /// https://github.com/neo-project/neo/blob/427a3cd08f61a33e98856e4b4312b8147708105a/neo/protocol.json#L4
    static const byte version = 0x17;

    /// Determines whether a string makes a valid NEO address.
    static bool isValid(const std::string &string);

    /// Initializes a NEO address with a string representation.
    explicit Address(const std::string &string) : TW::Base58Address<AddressSize>(string) {}

    /// Initializes a NEO address with a collection of bytes.
    explicit Address(const Data &data) : TW::Base58Address<AddressSize>(data) {}

    /// Initializes an address with a collection of public key.
    explicit Address(uint8_t m, const std::vector<Data>& publicKeys);

    /// Initializes a NEO address with a public key.
    explicit Address(const PublicKey &publicKey);

    /// Initializes a NEO address without a public key.
    explicit Address();

    Data toScriptHash(const Data &data) const;

    Data toScriptHash() const;
};

inline bool operator==(const Address& lhs, const Address& rhs) {
    return lhs.string() == rhs.string();
}

} // namespace TW::NEO