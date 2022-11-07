//
//  TransactionRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Vapor

public struct TransactionRequest: Content {

    private let transaction: Transaction

    public init(amount: Double, nonce: String, options: TransactionOptions, deviceData: String? = nil) {
        self.transaction = .init(amount: amount, deviceData: deviceData, paymentMethodNonce: nonce, options: options)
    }

}

private enum TransactionType: String, Codable {
    case sale, credit
}

private struct Transaction: Codable {
    let amount: Double
    let deviceData: String?
    let paymentMethodNonce: String
    let options: TransactionOptions
    var type: TransactionType = .sale
}
