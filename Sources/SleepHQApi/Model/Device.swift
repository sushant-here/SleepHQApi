//
//  SleepHQDevices.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 25/7/2024.
//

import Foundation

public struct Device: Decodable {

    public struct Attributes: Decodable {
        public let id: Int
        public let name: String
        public let brand: String
        public let deviceType: String
    }

    public let id: String
    public let type: String
    public let attributes: Attributes
}
