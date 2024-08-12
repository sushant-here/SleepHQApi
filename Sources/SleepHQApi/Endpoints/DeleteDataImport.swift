//
//  DeleteDataImport.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 30/7/2024.
//

import Foundation

public enum DeleteDataImport {
    public struct Request: Encodable {
        public let importId: Int

        public init(importId: Int) {
            self.importId = importId
        }
    }

    public struct Response: Decodable {
        public var data: DataImport
    }
}
