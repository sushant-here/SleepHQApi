//
//  User.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 24/7/2024.
//

import Foundation

public struct User: Decodable {
    public let id: Int
    public let email: String
    public let currentTeamId: Int
}
