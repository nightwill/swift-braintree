//
//  Http.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import XMLCoder
import Vapor

private let decoder: XMLDecoder = {
    let decoder = XMLDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()
private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
}()

struct Http {
    
    let application: Application
    let configuration: BraintreeConfiguration

    private let httpHeaders: HTTPHeaders
    
    init(application: Application, configuration: BraintreeConfiguration) throws {
        self.application = application
        self.configuration = configuration
        self.httpHeaders = try configuration.httpHeaders()
    }

    func get<Response: Codable>(_ url: String) async throws -> Response {
        try await send(method: .GET, url: url) {
            try await application.client.get($0)
        }
    }

    func post<Response: Codable>(_ url: String) async throws -> Response {
        try await post(url, payload: EmptyPayload())
    }
    
    func post<Payload: Content, Response: Codable>(
        _ url: String,
        payload: Payload,
        desiredCode: Int? = nil
    ) async throws -> Response {
        try await send(method: .POST, url: url) {
            print(String(data: try! encoder.encode(payload), encoding: .utf8))
            return try await application.client.post($0, headers: httpHeaders, beforeSend: { try $0.content.encode(payload, using: encoder) })
        }
    }
    
    func put<Payload: Content, Response: Codable>(_ url: String, payload: Payload) async throws -> Response {
        try await send(method: .PUT, url: url) {
            try await application.client.post($0, headers: httpHeaders, beforeSend: { try $0.content.encode(payload, using: encoder) })
        }
    }
    
    func delete<Response: Codable>(_ url: String) async throws -> Response {
        try await send(method: .DELETE, url: url) {
            try await application.client.delete($0, headers: httpHeaders)
        }
    }

    // MARK: - Arrays

    func _getArray<T: Codable>(_ url: String) async throws -> [T] {
        do {
            return try await get(url)
        } catch {
            return try throwOrReturnEmptyArray(error)
        }
    }

    func _postArray<T: Codable>(_ url: String) async throws -> [T] {
        try await _postArray(url, payload: EmptyPayload())
    }

    func _postArray<Payload: Content, T: Codable>(_ url: String, payload: Payload) async throws -> [T] {
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
        let response = try await action(makeURI(url))

        try check(response: response, url: url)

        return try decode(response: response)
    }
    
    private func decode<T>(response: ClientResponse) throws -> T where T: Codable {
        let result = try response.content.decode(T.self, using: decoder)
        // print("decoded: \(result)")
        return result
    }

    private func makeURI(_ url: String) -> URI {
        .init(stringLiteral: configuration.baseURL + url)
    }

    private func check(response: ClientResponse, url: String) throws {
        guard (200..<300) ~= response.status.code else {
            print(try? response.content.decode(String.self, using: decoder))
            if let errorResponse = try? response.content.decode(APIErrorResponse.self, using: decoder) {
                throw errorResponse.message
            } else {
                throw "Braintree API returned status: \(response.status.code) url: \(configuration.baseURL + url)"
            }
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

private extension BraintreeConfiguration {

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
            throw "Unable to encode authorization credentials to base64"
        }
        return "Basic " + base64String.trimmingCharacters(in: .whitespaces)
    }

}

private struct EmptyPayload: Content { }
