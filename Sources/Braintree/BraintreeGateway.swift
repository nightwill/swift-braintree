//
//  BraintreeGateway.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import Vapor

public struct BraintreeGateway {

    let configuration: BraintreeConfiguration
    let http: Http
    
    /// Instantiates a BraintreeGateway. Use the values provided by Braintree
    public init(application: Application, configuration: BraintreeConfiguration) throws {
        self.configuration = configuration
        self.http = try Http(application: application, configuration: configuration)
    }
    
    public var clientToken: ClientTokenGateway {
        return ClientTokenGateway(http: http, configuration: configuration)
    }
    
    public var transaction: TransactionGateway {
        return TransactionGateway(http: http, configuration: configuration)
    }

}
