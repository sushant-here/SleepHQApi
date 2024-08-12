//
//  MD5Utils.swift
//  SleepHQ Uploader
//
//  Created by Sushant Verma on 28/7/2024.
//

import Foundation
import CryptoKit

/// From: https://powermanuscript.medium.com/swift-5-2-macos-md5-hash-for-some-simple-use-cases-66be9e274182
extension String {
    public var md5Hash: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Data {
    public var md5Hash: String {
        let computed = Insecure.MD5.hash(data: self)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
