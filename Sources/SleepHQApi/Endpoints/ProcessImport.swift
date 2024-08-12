//
//  ProcessImport.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 1/8/2024.
//

public enum ProcessImport {
    public struct Request: Encodable {
        public let importId: Int

        public init(importId: Int) {
            self.importId = importId
        }
    }

    public struct Response: Decodable {
        public var data: String
    }
}
