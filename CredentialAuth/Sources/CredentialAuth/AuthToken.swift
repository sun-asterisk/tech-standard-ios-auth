import Foundation

/// A protocol that contains access token, refresh token and expired date.
public protocol AuthToken: Codable {
    var refreshToken: String { get }
    var expiredDate: Date { get }
}

public extension AuthToken {
    var isExpired: Bool {
        expiredDate < Date()
    }
}
