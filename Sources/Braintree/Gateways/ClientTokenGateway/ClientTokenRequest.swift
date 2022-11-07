//
//  ClientTokenRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Vapor

public struct ClientTokenRequest: Content {

    let clientToken: ClientToken

    public init(customerId: String? = nil, options: ClientTokenOptions? = nil) {
        self.clientToken = .init(customerId: customerId, clientTokenOptions: options)
    }

}

struct ClientToken: Codable {
    let customerId: String?
    let clientTokenOptions: ClientTokenOptions?
    var version: Int = 2
}
