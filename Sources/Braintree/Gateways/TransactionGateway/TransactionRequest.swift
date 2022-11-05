//
//  TransactionRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Vapor

public final class TransactionRequest: Content {

    let amount: Double
    let deviceData: String?
    let paymentMethodID: String
    let transactionOptionsRequest: TransactionOptionsRequest

    public init(amount: Double, paymentMethodID: String, transactionOptionsRequest: TransactionOptionsRequest, deviceData: String? = nil) {
        self.amount = amount
        self.deviceData = deviceData
        self.paymentMethodID = paymentMethodID
        self.transactionOptionsRequest = transactionOptionsRequest
    }

}
