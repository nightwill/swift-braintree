import Foundation

public struct ClientTokenResponse: Codable {

    public let value: String

    public var token: String {
        let data = value.data(using: .utf8)!
        let token = try! JSONDecoder().decode(Token.self, from: data)
        return token.authorizationFingerprint
    }

}

private struct Token: Codable {
    let authorizationFingerprint: String
}
