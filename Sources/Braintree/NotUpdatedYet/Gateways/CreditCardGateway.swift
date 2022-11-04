//
//  CreditCardGateway.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import Vapor

public struct CreditCardGateway {

    let http: Http
    let configuration: Configuration
    
    public init(http: Http, configuration: Configuration) {
        self.http = http
        self.configuration = configuration
    }
    
    public func create(request: CreditCardRequest) async throws -> CreditCard {
        try await http.post(configuration.paymentMethodsPath, payload: request, desiredCode: 201)
    }
    
    public func find(token: String) async throws -> CreditCard {
        try await http.get(configuration.paymentMethodsPath + "/credit_card/" + token)
    }
    
    public func expired() async throws -> [String] {

        struct Response: Codable {
            struct Item: Codable {
                let item: String?
                let type: String
            }

            let pageSize: Int
            let ids: [Item]
            
            private enum CodingKeys : String, CodingKey {
                case pageSize = "page-size", ids
            }
        }

        let response: Response = try await http.post(configuration.paymentMethodsPath + "/all/expired_ids")
        print("resp.pageSize: \(response.pageSize) resp.ids.count: \(response.ids.count)")
        return response.ids.compactMap { $0.item }
    }

}

private extension Configuration {

    var paymentMethodsPath: String {
        merchantPath + "/payment_methods"
    }

}
