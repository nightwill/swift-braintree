//
//  AddressGateway.swift
//  Braintree
//
//  Created by Mihael Isaev on 27/09/2018.
//

import Foundation
import Vapor

public struct AddressGateway {

    let http: Http
    let configuration: Configuration
    
    public init(http: Http, configuration: Configuration) {
        self.http = http
        self.configuration = configuration
    }
    
    public func find(customerId: String, addressID: String) async throws -> Address {
        let path = configuration.addressPath(customerID: customerId, addressID: addressID)
        return try await http.get(path)
    }
    
    public func create(customerID: String, request: AddressRequest) async throws -> Address {
        let path = configuration.addressesPath(customerID: customerID)
        return try await http.post(path, payload: request)
    }
    
    public func update(customerId: String, addressID: String, request: AddressRequest) async throws -> Address {
        let path = configuration.addressPath(customerID: customerId, addressID: addressID)
        return try await http.put(path, payload: request)
    }
    
    public func delete(customerId: String, addressID: String) async throws -> Address {
        let path = configuration.addressPath(customerID: customerId, addressID: addressID)
        return try await http.delete(path)
    }

}

private extension Configuration {

    func addressesPath(customerID: String) -> String {
        merchantPath + "/customers/\(customerID)/addresses"
    }

    func addressPath(customerID: String, addressID: String) -> String {
        addressesPath(customerID: customerID) + "/" + addressID
    }

}
