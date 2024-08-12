//
//  OAuthLogin.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 24/7/2024.
//

import Foundation

public enum OAuthLogin {
    public enum Scope: String {
        case read
        case write
        case delete
    }
    public struct Request: Encodable {
        let grantType: String = "password"
        let scope: String
        let clientId: String
        let clientSecret: String

        public init(clientId: String, clientSecret: String, scope: [Scope] = [.read]) {
            self.clientId = clientId
            self.clientSecret = clientSecret

            self.scope = scope.map({$0.rawValue}).joined(separator: " ")
        }
    }
    
    public struct Response: Decodable {
        public let accessToken: String
        public let tokenType: String
        public let expiresIn: Int
        public let refreshToken: String
        public let scope: String
        public let createdAt: Int
    }
}
