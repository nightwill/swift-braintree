//
//  AddOnGateway.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import Vapor

public struct AddOnGateway {

    let http: Http
    let configuration: Configuration
    
    public init(http: Http, configuration: Configuration) {
        self.http = http
        self.configuration = configuration
    }
    
    public func all() async throws -> [AddOn] {
        try await http._getArray(configuration.merchantPath + "/add_ons")
    }

}
