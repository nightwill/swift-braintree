//
//  TransactionOptionsRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Vapor

public struct TransactionOptions: Content {
    
    let submitForSettlement: Bool

    public init(submitForSettlement: Bool) {
        self.submitForSettlement = submitForSettlement
    }
    
}
