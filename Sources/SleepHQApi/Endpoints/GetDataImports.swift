//
//  GetDataImports.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 25/7/2024.
//

import Foundation

public enum GetDataImports {
    public struct Request: Encodable {
        public let teamId: Int
        public let page: Int?
        public let perPage: Int?

        public init(teamId: Int, 
                    page: Int? = nil,
                    perPage: Int? = nil) {
            self.teamId = teamId
            self.page = page
            self.perPage = perPage
        }
    }

    public struct Response: Decodable {
        public var data: [DataImport]
    }
}
