//
//  GetAllFiles.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 30/7/2024.
//

import Foundation

public enum GetAllFiles {
    public struct Request: Encodable {
        public let teamId: Int

        public init(teamId: Int) {
            self.teamId = teamId
        }
    }

    public struct Response: Decodable {
        public var data: [FileImport]

        public var loadMore: Bool?

        init(data: [FileImport]) {
            self.data = data
        }
    }
}
