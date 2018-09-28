//
//  UsBankAccountVerificationConfirmRequest.swift
//  Braintree
//
//  Created by Mihael Isaev on 28/09/2018.
//

import Foundation
import Vapor

public final class UsBankAccountVerificationConfirmRequest: Content {
    private var depositAmounts: [Int64]
}
