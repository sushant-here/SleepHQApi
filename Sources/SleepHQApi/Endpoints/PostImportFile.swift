//
//  PostImportFile.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 30/7/2024.
//

import Foundation

public enum PostImportFile {
    public struct Request: Encodable {
        public let importId: Int
        public let file: URL
        public let fileHash: String
        public let fromCard: URL

        public init(importId: Int, file: URL, fileHash: String, fromCard: URL) {
            self.importId = importId
            self.file = file
            self.fileHash = fileHash
            self.fromCard = fromCard
        }
    }

    public struct Response: Decodable {
        public var data: FileImport
    }
}
