//
//  SleepHQProdApi.swift
//
//
//  Created by Sushant Verma on 12/8/2024.
//

import Foundation

public class SleepHQProdApi: SleepHQApi {
    public var accessToken: String?

    public let baseUrl = "https://sleephq.com"

    public init() {}

    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    private var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    private enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    private func buildRequest(_ method: HttpMethod,
                              _ urlString: String,
                              authenticated: Bool = true) throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = method.rawValue

        urlRequest.addValue("application/json",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/vnd.api+json",
                            forHTTPHeaderField: "accept")
        if authenticated {
            guard let accessToken = accessToken else {
                throw SleepHQApiError.noAccessToken
            }
            urlRequest.addValue("Bearer \(accessToken)",
                                forHTTPHeaderField: "authorization")
        }

        return urlRequest
    }

    private func performRequest(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let delegate = URLSessionProgressDelegate()
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)

        let (data, urlResponse) = try await session.data(for: urlRequest)
        if let urlResponse = urlResponse as? HTTPURLResponse {
            print("REQUEST: \(urlRequest.url!) -> Response: \(urlResponse.statusCode)")
        }
        return (data, urlResponse)
    }

    public func auth(_ request: OAuthLogin.Request) async throws -> OAuthLogin.Response {
        var urlRequest = try buildRequest(.post, "\(baseUrl)/oauth/token", authenticated: false)

        urlRequest.httpBody = try jsonEncoder.encode(request)

        let (data, _) = try await performRequest(for: urlRequest)
        let response = try jsonDecoder.decode(OAuthLogin.Response.self, from: data)
        accessToken = response.accessToken
        return response
    }

    public func whoami() async throws -> GetMe.Response {
        let urlRequest = try buildRequest(.get, "\(baseUrl)/api/v1/me")

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(GetMe.Response.self, from: data)
    }

    public func fetchDevices() async throws -> GetDevices.Response {
        let urlRequest = try buildRequest(.get, "\(baseUrl)/api/v1/devices")

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(GetDevices.Response.self, from: data)
    }

    public func getAllFiles(_ request: GetAllFiles.Request) async throws -> GetAllFiles.Response {
        var page = 1
        var loadMoreData = true
        var allFiles: [FileImport] = []
        while loadMoreData {
            let currentPageResponse = try await getFiles(team: request.teamId, page: page)
            allFiles.append(contentsOf: currentPageResponse.data)
            page += 1

            loadMoreData = currentPageResponse.loadMore == true
        }

        return .init(data: allFiles)
    }

    private func getFiles(team: Int, page: Int, perPage: Int = 100) async throws -> GetAllFiles.Response {
        var urlRequest = try buildRequest(.get, "\(baseUrl)/api/v1/teams/\(team)/files")

        urlRequest.url?.append(queryItems: [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ])

        let (data, urlResponse) = try await performRequest(for: urlRequest)
        var decodedResponse = try jsonDecoder.decode(GetAllFiles.Response.self, from: data)

        if let urlResponse = urlResponse as? HTTPURLResponse,
           let totalFilesHeader = urlResponse.value(forHTTPHeaderField: "total"),
           let totalFiles = Int(totalFilesHeader) {
            let totalLoaded = page * perPage

            decodedResponse.loadMore = totalLoaded < totalFiles
        }
        return decodedResponse
    }

    public func fetchImports(_ request: GetDataImports.Request) async throws -> GetDataImports.Response {
        var urlRequest = try buildRequest(.get, "\(baseUrl)/api/v1/teams/\(request.teamId)/imports")

        if let page = request.page {
            urlRequest.url?.append(queryItems: [
                URLQueryItem(name: "page", value: String(page))
            ])
        }
        if let perPage = request.perPage {
            urlRequest.url?.append(queryItems: [
                URLQueryItem(name: "per_page", value: String(perPage))
            ])
        }

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(GetDataImports.Response.self, from: data)
    }

    public func createImport(_ request: PostDataImports.Request) async throws -> PostDataImports.Response {
        var urlRequest = try buildRequest(.post, "\(baseUrl)/api/v1/teams/\(request.teamId)/imports")
        urlRequest.httpBody = try jsonEncoder.encode(request)

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(PostDataImports.Response.self, from: data)
    }

    public func deleteImport(_ request: DeleteDataImport.Request) async throws -> DeleteDataImport.Response {
        let urlRequest = try buildRequest(.delete, "\(baseUrl)/api/v1/imports/\(request.importId)")

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(DeleteDataImport.Response.self, from: data)
    }

    public func importFile(_ request: PostImportFile.Request) async throws -> PostImportFile.Response {
        var urlRequest = try buildRequest(.post, "\(baseUrl)/api/v1/imports/\(request.importId)/files")

        let requestBuilder = MultiPartRequestBuilder(for: &urlRequest)

        let cardRoot = request.fromCard.standardizedFileURL.absoluteString
        let folderPath = request.file.standardizedFileURL.deletingLastPathComponent().absoluteString

        guard folderPath.hasPrefix(cardRoot) else {
            throw SleepHQApiError.invalidImportRoot
        }

        let relativePath = "./\(folderPath.dropFirst(cardRoot.count))"

        try requestBuilder.addField("name", value: request.file.lastPathComponent)
        try requestBuilder.addField("path", value: relativePath)
        try requestBuilder.addField("content_hash", value: request.file.calculateSleepHQContentHash())
        try requestBuilder.addField("file", file: request.file)

        urlRequest.httpBody = requestBuilder.buildBody()

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(PostImportFile.Response.self, from: data)
    }

    public func processImport(_ request: ProcessImport.Request) async throws -> ProcessImport.Response {
        let urlRequest = try buildRequest(.post, "\(baseUrl)/api/v1/imports/\(request.importId)/process_files")

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(ProcessImport.Response.self, from: data)
    }

    public func calculateContentHash(_ request: CalculateContentHash.Request) async throws -> CalculateContentHash.Response {
        var urlRequest = try buildRequest(.post, "\(baseUrl)/api/v1/imports/files/calculate_content_hash")

        let requestBuilder = MultiPartRequestBuilder(for: &urlRequest)

        try requestBuilder.addField("name", value: request.fileName)
        try requestBuilder.addField("file", file: request.file)

        urlRequest.httpBody = requestBuilder.buildBody()

        let (data, _) = try await performRequest(for: urlRequest)
        return try jsonDecoder.decode(CalculateContentHash.Response.self, from: data)
    }

}
