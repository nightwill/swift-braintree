import Foundation

public enum TransactionStatus: String, Codable {
    case authorizationExpired = "authorization_expired"
    case authorizing = "authorizing"
    case authorized = "authorized"
    case gatewayRejected = "gateway_rejected"
    case failed = "failed"
    case processorDeclined = "processor_declined"
    case settled = "settled"
    case settling = "settling"
    case submittedForSettlement = "submitted_for_settlement"
    case voided = "voided"
    case unrecognized = "unrecognized"
    case settlementDeclined = "settlement_declined"
    case settlementPending = "settlement_pending"
    case settlementConfirmed = "settlement_confirmed"
}
