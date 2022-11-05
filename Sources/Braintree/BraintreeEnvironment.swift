//
//  BraintreeEnvironment.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation

public enum BraintreeEnvironment: String, Codable {

    /// For production.
    case production
    
    /// For merchants to use during their development and testing.
    case sandbox
    
    var baseURL: String {
        switch self {
        case .production: return "https://api.braintreegateway.com:443"
        case .sandbox: return "https://api.sandbox.braintreegateway.com:443"
        }
    }

}
