//
//  FileImport.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 30/7/2024.
//

import Foundation

public struct FileImport: Decodable {

    public struct Attributes: Decodable {
        public let id: Int
        public let addedById: Int?
        public let addedByType: String?
        public let contentHash: String?
        public let teamId: Int?
        public let name: String?
        public let path: String?
        public let size: Int?

        // public let createdAt: Date
        // public let updatedAt: Date
    }

    public let id: String
    public let type: String
    public let attributes: Attributes
}
