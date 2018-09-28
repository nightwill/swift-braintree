//
//  CreditCardVerificationRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Foundation
import Vapor

public final class CreditCardVerificationRequest: Content {
    private var creditCardRequest: CreditCardVerificationCreditCardRequest
    private var optionsRequest: CreditCardVerificationOptionsRequest
}
