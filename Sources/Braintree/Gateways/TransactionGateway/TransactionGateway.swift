//
//  TransactionGateway.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import Vapor

public struct TransactionGateway {
    let http: Http
    let configuration: BraintreeConfiguration
    
    init(http: Http, configuration: BraintreeConfiguration) {
        self.http = http
        self.configuration = configuration
    }

    public func sale(_ request: TransactionRequest) async throws -> TransactionResponse {
        return try await http.post(configuration.merchantPath + "/transactions/", payload: request)
    }
}
