//
//  Encryption.swift
//  BaseApp
//
//  Created by Omar Brugna on 17/06/2020.
//

import Foundation
import CommonCrypto

public class Encryption {
    
    public static func hash(_ string: String?) -> String {
        if !TextUtils.isEmpty(string) {
            let data = string!.data(using: String.Encoding.utf8)!
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            CC_SHA256((data as NSData).bytes, CC_LONG(data.count), &digest)
            let hexBytes = digest.map { String(format: "%02hhx", $0) }
            return hexBytes.joined(separator: "")
        } else {
            Logger.e("Trying to hash an empty string")
        }
        return Constants.EMPTY
    }
}
