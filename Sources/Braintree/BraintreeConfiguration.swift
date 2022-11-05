//
//  BraintreeConfiguration.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation

public struct BraintreeConfiguration {

    let environment: BraintreeEnvironment

    let merchantId: String
    let publicKey: String
    let privateKey: String
    
    let version = "1.0"
    let apiVersion = "4"

    public init(environment: BraintreeEnvironment, merchantId: String, publicKey: String, privateKey: String) throws {
        self.environment = environment
        
        guard !merchantId.isEmpty else {
            throw "MerchantId needs to be set"
        }
        self.merchantId = merchantId
        
        guard !publicKey.isEmpty else {
            throw "PublicKey needs to be set"
        }
        self.publicKey = publicKey
        
        guard !privateKey.isEmpty else {
            throw "PrivateKey needs to be set"
        }
        self.privateKey = privateKey
    }
    
    public var baseURL: String {
        environment.baseURL
    }
    
    public var merchantPath: String {
        "/merchants/" + merchantId
    }

}
