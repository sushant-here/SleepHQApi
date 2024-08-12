//
//  GetMe.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 24/7/2024.
//

import Foundation

public enum GetMe {
    public struct Response: Decodable {
        public var data: User
    }
}
