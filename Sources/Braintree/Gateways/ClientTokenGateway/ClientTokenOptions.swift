//
//  ClientTokenOptionsRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Vapor

public struct ClientTokenOptions: Content {

    let makeDefault: Bool?
    let verifyCard: Bool?
    let failOnDuplicatePaymentMethod: Bool?

    public init(makeDefault: Bool? = nil, verifyCard: Bool? = nil, failOnDuplicatePaymentMethod: Bool? = nil) {
        self.makeDefault = makeDefault
        self.verifyCard = verifyCard
        self.failOnDuplicatePaymentMethod = failOnDuplicatePaymentMethod
    }

}
