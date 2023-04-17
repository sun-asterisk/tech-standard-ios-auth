import Foundation

/// A protocol that contains access token, refresh token and expired date.
public protocol AuthToken {
    /// A `String` property that represents an access token used to authenticate a user.
    var accessToken: String { get }
    
    /// A `String` property that represents a refresh token used to obtain a new access token when the current one expires.
    var refreshToken: String { get }
    
    /// A `Date` property that represents the date and time when the access token will expire.
    var expiredDate: Date { get }
    
    /// A method that takes a key as a `String` parameter and saves the authentication token with that key. This method can throw an error if the authentication token fails to save.
    func save(key: String) throws
    
    /// A static method that takes a key as a `String` parameter and returns an instance of the `Self` type, which is a type that conforms to the `AuthToken` protocol. If there is no authentication token with the specified key, this method returns nil.
    static func get(key: String) -> Self?
    
    /// A static method that takes a key as a `String` parameter and removes the authentication token with that key. This method can throw an error if the authentication token fails to remove.
    static func remove(key: String) throws
}

public extension AuthToken {
    /// A `Boolean` value indicating whether the access token represented by the conforming type has expired or not.
    var isExpired: Bool {
        expiredDate < Date()
    }
}
