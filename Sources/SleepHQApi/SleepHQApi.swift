//
//  SleepHQApi.swift
//  SleepHQApi
//
//
//  Created by Sushant Verma on 12/8/2024.
//

public protocol SleepHQApi {
    var accessToken: String? { get }

    @discardableResult
    func auth(_ request: OAuthLogin.Request) async throws -> OAuthLogin.Response
    func whoami() async throws -> GetMe.Response
    func fetchDevices() async throws -> GetDevices.Response

    func getAllFiles(_ request: GetAllFiles.Request) async throws -> GetAllFiles.Response
    func fetchImports(_ request: GetDataImports.Request) async throws -> GetDataImports.Response
    func createImport(_ request: PostDataImports.Request) async throws -> PostDataImports.Response
    func deleteImport(_ request: DeleteDataImport.Request) async throws -> DeleteDataImport.Response
    func importFile(_ request: PostImportFile.Request) async throws -> PostImportFile.Response
    func processImport(_ request: ProcessImport.Request) async throws -> ProcessImport.Response

    func calculateContentHash(_ request: CalculateContentHash.Request) async throws -> CalculateContentHash.Response
}
