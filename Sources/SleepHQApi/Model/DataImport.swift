//
//  SleepHQImport.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 25/7/2024.
//

import Foundation

public struct DataImport: Decodable {

    public struct Attributes: Decodable {
        public let id: Int
        public let teamId: Int
        public let name: String?
        public let status: String
        public let fileSize: Int?
        public let progress: Int?
        public let machineId: Int?
        public let deviceId: Int?
        public let programatic: Bool

        // public let createdAt: Date
        // public let updatedAt: Date
    }

    public let id: String
    public let type: String
    public let attributes: Attributes
}
