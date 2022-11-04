//
//  ClientTokenGateway.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import Vapor

public struct ClientTokenGateway {

    let http: Http
    let configuration: Configuration
    
    public init(http: Http, configuration: Configuration) {
        self.http = http
        self.configuration = configuration
    }
    
    public func generate(request: ClientTokenRequest) async throws -> ClientTokenResponse {
        try verifyOptions(request: request)
        return try await http.post(configuration.merchantPath + "/client_token/", payload: request)
    }
    
    private func verifyOptions(request: ClientTokenRequest) throws {
        if let options = request.options, request.customerId == nil {
            var invalidOptions: [String] = []
            if options.verifyCard != nil {
                invalidOptions.append("VerifyCard")
            }
            if options.makeDefault != nil {
                invalidOptions.append("MakeDefault")
            }
            if options.failOnDuplicatePaymentMethod != nil {
                invalidOptions.append("FailOnDuplicatePaymentMethod")
            }
            if !invalidOptions.isEmpty {
                throw BraintreeError(.unexpected, reason: "Following arguments are invalid without customerId: " + invalidOptions.joined(separator: ", "))
            }
        }
    }
    
}
