//
//  ClientTokenRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Foundation

public struct ClientTokenRequest: BraintreeContent {

    public static var key: String = "client-token"

    public let customerId: String?
    public let options: ClientTokenOptions?
    public let version: Int = 2
    //public let merchantAccountId: String
    
    private enum CodingKeys : String, CodingKey {
        case customerId = "customer-id"
        case options
        case version
        //case merchantAccountId = "merchant-account-id"
    }

    public init(customerId: String? = nil, options: ClientTokenOptions? = nil) {
        //self.merchantAccountId = merchantAccountId
        self.customerId = customerId
        self.options = options
    }

}
