//
//  Http.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import XMLParsing
import Vapor

public protocol BraintreeContent: Content {
    static var key: String { get }
}

public final class EmptyPayload: BraintreeContent {
    public static var key: String = ""
    public init() {}
}

public struct Http {

    public struct File: Codable {
        public var filename: String
        public var data: Data
        public var contentType: String?
        public var ext: String?
    }
    
    let application: Application
    let configuration: Configuration

    private let httpHeaders: HTTPHeaders
    
    public init(application: Application, configuration: Configuration) throws {
        self.application = application
        self.configuration = configuration
        self.httpHeaders = try configuration.httpHeaders()
    }

    public func get<Response: Codable>(_ url: String) async throws -> Response {
        try await send(method: .GET, url: url) {
            try await application.client.get($0)
        }
    }

    public func post<Response: Codable>(_ url: String) async throws -> Response {
        try await post(url, payload: EmptyPayload())
    }
    
    public func post<Payload: BraintreeContent, Response: Codable>(
        _ url: String,
        payload: Payload,
        desiredCode: Int? = nil
    ) async throws -> Response {
        try await send(method: .POST, url: url) {
            try await application.client.post($0, headers: httpHeaders, content: [Payload.key: payload])
        }
    }
    
    public func put<Payload: BraintreeContent, Response: Codable>(_ url: String, payload: Payload) async throws -> Response {
        try await send(method: .PUT, url: url) {
            try await application.client.post($0, headers: httpHeaders, content: payload)
        }
    }
    
    public func delete<Response: Codable>(_ url: String) async throws -> Response {
        try await send(method: .DELETE, url: url) {
            try await application.client.delete($0, headers: httpHeaders)
        }
    }

    // MARK: - Arrays

    public func _getArray<T: Codable>(_ url: String) async throws -> [T] {
        do {
            return try await get(url)
        } catch {
            return try throwOrReturnEmptyArray(error)
        }
    }

    public func _postArray<T: Codable>(_ url: String) async throws -> [T] {
        try await _postArray(url, payload: EmptyPayload())
    }

    public func _postArray<Payload: BraintreeContent, T: Codable>(_ url: String, payload: Payload) async throws -> [T] {
        do {
            return try await post(url, payload: payload)
        } catch {
            return try throwOrReturnEmptyArray(error)
        }
    }

    private func send<Response: Codable>(
        method: HTTPMethod,
        url: String,
        action: (URI) async throws -> ClientResponse
    ) async throws -> Response {
        log(method: method, url: url)
        let response = try await action(makeURI(url))
        log(method: method, url: url, status: response.status)

        try check(response: response, url: url)

        return try decode(response: response)
    }
    
    private func decode<T>(response: ClientResponse) throws -> T where T: Codable {
        let result = try response.content.decode(T.self, using: XMLDecoder())
        // print("decoded: \(result)")
        return result
    }

    private func log(method: HTTPMethod, url: String, status: HTTPStatus? = nil) {
        if let status = status {
            configuration.logger.log(.fine, message: "\(Date()) \(method.rawValue) \(url) \(status.code)")
        } else {
            configuration.logger.log(.info, message: "\(Date()) \(method.rawValue) \(url)")
        }
    }

    private func makeURI(_ url: String) -> URI {
        .init(stringLiteral: configuration.baseURL + url)
    }

    private func check(response: ClientResponse, url: String) throws {
        guard (200..<300) ~= response.status.code else {
            throw BraintreeError(
                .server,
                reason: "Braintree API returned status: \(response.status.code) url: \(configuration.baseURL + url)"
            )
        }
    }

    private func throwOrReturnEmptyArray<T: Codable>(_ error: Error) throws -> [T] {
        if "\(error)".contains("Index 0") {
            return []
        } else {
            throw error
        }
    }

}


private extension Configuration {

    func httpHeaders() throws -> HTTPHeaders {
        [
            "Accept": "application/xml",
            "User-Agent": "Braintree Swift " + version,
            "X-ApiVersion": apiVersion,
            "Authorization": try authorizationHeader(),
            "Content-Type": "application/json"
        ]
    }

    private func authorizationHeader() throws -> String {
        let credentials = "\(publicKey):\(privateKey)"
        guard let base64String = credentials.data(using: .utf8)?.base64EncodedString() else {
            throw BraintreeError(.configuration, reason: "Unable to encode authorization credentials to base64")
        }
        return "Basic " + base64String.trimmingCharacters(in: .whitespaces)
    }

}
