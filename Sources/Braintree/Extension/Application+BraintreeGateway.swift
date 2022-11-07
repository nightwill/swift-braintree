import Vapor

public extension Application {

    private struct Key: StorageKey {
        typealias Value = BraintreeGateway
    }

    var braintreeGateway: BraintreeGateway {
        get {
            guard let value = storage[Key.self] else {
                fatalError("BraintreeGateway not setup. Use application.braintreeGateway = ...")
            }
            return value
        }
        set {
            storage[Key.self] = newValue
        }
    }

}
