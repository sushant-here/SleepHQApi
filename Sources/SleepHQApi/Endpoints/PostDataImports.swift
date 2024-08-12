//
//  PostDataImports.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 25/7/2024.
//

public enum PostDataImports {
    public struct Request: Encodable {
        public let teamId: Int
        public let programatic: Bool?
        public let deviceId: Int?

        public init(teamId: Int, programatic: Bool? = false, deviceId: Int? = nil) {
            self.teamId = teamId
            self.programatic = programatic
            self.deviceId = deviceId
        }
    }

    public struct Response: Decodable {
        public var data: DataImport
    }
}
