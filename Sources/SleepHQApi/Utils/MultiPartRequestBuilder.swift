//
//  MultiPartRequestBuilder.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 28/7/2024.
//

import Foundation

// fileprivate
extension Data {
    mutating func append(_ content: String) {
        append(content.data(using: .utf8)!)
    }
}

/// Inspired by: https://medium.com/@bondarenkotatiana96/multipart-form-data-in-swift-078d29cdf4e5
class MultiPartRequestBuilder {
    enum Error: Swift.Error {
        case alreadyBuilt
    }

    private let boundary = "Boundary-\(UUID().uuidString)"
    private var builtData = Data()
    private var isBuilt = false

    init(for urlRequest: inout URLRequest) {
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)",
                            forHTTPHeaderField: "Content-Type")
    }

    // https://medium.com/@bondarenkotatiana96/multipart-form-data-in-swift-078d29cdf4e5
    func addField(_ name: String, value: String) throws {
        guard !isBuilt else { throw Error.alreadyBuilt }

        var field = Data()
        field.append("--\(boundary)")
        field.append("\r\n")

        field.append("Content-Disposition: form-data; name=\"\(name)\"")
        field.append("\r\n\r\n\(value)\r\n")

        builtData.append(field)
    }

    func addField(_ name: String, imageData: Data, filename: String) throws {
        guard !isBuilt else { throw Error.alreadyBuilt }

        var field = Data()
        field.append("--\(boundary)")
        field.append("\r\n")

        field.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"")
        field.append("\r\n")
        
        field.append("Content-Type: image/jpeg")
        field.append("\r\n")

        field.append("\r\n")
        field.append(imageData)
        field.append("\r\n")

        builtData.append(field)
    }

    func addField(_ name: String, file: URL) throws {
        guard !isBuilt else { throw Error.alreadyBuilt }

        let fileData = try Data(contentsOf: file)

        var field = Data()
        field.append("--\(boundary)")
        field.append("\r\n")

        field.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(file.lastPathComponent)\"")
        field.append("\r\n")
        field.append("Content-Type: application/octet-stream")
        field.append("\r\n")

        field.append("\r\n")
        field.append(fileData)
        field.append("\r\n")

        builtData.append(field)
    }

    func buildBody() -> Data {
        guard !isBuilt else { return builtData }

        var field = Data()
        field.append("--\(boundary)")
        field.append("--")
        field.append("\r\n")

        builtData.append(field)
        isBuilt = true

        return builtData
    }

}
