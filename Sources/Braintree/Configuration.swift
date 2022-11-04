//
//  Configuration.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation

public struct Configuration {

    public let environment: BraintreeEnvironment

    public let merchantId: String
    public let publicKey: String
    public let privateKey: String
    
    public let version = "1.0"
    public let graphQLApiVersion = "2018-05-21"
    public let apiVersion = "4"
    public let timeout: TimeInterval = 60
    public let connectTimeout: TimeInterval = 60

    let logger: Logger
    
    public init(environment: BraintreeEnvironment, merchantId: String, publicKey: String, privateKey: String) throws {
        self.environment = environment
        
        guard !merchantId.isEmpty else {
            throw BraintreeError(.configuration, reason: "merchantId needs to be set")
        }
        self.merchantId = merchantId
        
        guard !publicKey.isEmpty else {
            throw BraintreeError(.configuration, reason: "publicKey needs to be set")
        }
        self.publicKey = publicKey
        
        guard !privateKey.isEmpty else {
            throw BraintreeError(.configuration, reason: "privateKey needs to be set")
        }
        self.privateKey = privateKey
        self.logger = Logger()
    }
    
    public var baseURL: String {
        environment.baseURL
    }
    
    public var merchantPath: String {
        "/merchants/" + merchantId
    }
    
    public var graphQLURL: String {
        environment.graphQLURL
    }

}
