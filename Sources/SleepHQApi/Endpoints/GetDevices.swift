//
//  SleepHQDevices.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 25/7/2024.
//

import Foundation

public enum GetDevices {
    public struct Response: Decodable {
        public var data: [Device]
    }
}
