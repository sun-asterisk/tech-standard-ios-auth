import Foundation

/// A protocol that contains access token, refresh token and expired date.
public protocol AuthToken: Codable {
    /// A `String` property that represents an access token used to authenticate a user.
    var accessToken: String { get }
    
    /// A `String` property that represents a refresh token used to obtain a new access token when the current one expires.
    var refreshToken: String { get }
    
    /// A `Date` property that represents the date and time when the access token will expire.
    var expiredDate: Date { get }
}

public extension AuthToken {
    /// A `Boolean` value indicating whether the access token represented by the conforming type has expired or not.
    var isExpired: Bool {
        expiredDate < Date()
    }
}
