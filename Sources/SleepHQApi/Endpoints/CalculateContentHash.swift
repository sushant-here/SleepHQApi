//
//  CalculateContentHash.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 28/7/2024.
//

import Foundation

public enum CalculateContentHash {
    public struct Request {
        public let fileName: String
        public let file: URL

        public init(fileName: String, file: URL) {
            self.fileName = fileName
            self.file = file
        }
    }

    public struct Response: Decodable {
        public var data: ContentHash
    }
}
