//
//  SleepHQContentHash.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 28/7/2024.
//

import Foundation

extension URL {
    public func calculateSleepHQContentHash() throws -> String {
        var calculatedHashData = try Data(contentsOf: self)
        calculatedHashData.append(self.lastPathComponent.data(using: .utf8)!)
        return calculatedHashData.md5Hash
    }
}
