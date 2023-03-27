import XCTest
@testable import CredentialAuth

final class MockCredentialAuthDelegate: CredentialAuthDelegate, Mock {
    enum Action: Equatable {
        case login
        case logout
        case refreshToken(refreshToken: String)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        actions = .init(expected: expected)
    }
    
    // Login
    var loginSuccess = true
    var mockToken: MockToken!
    var mockUser: MockUser!
    var mockError: MockError!
    
    // Logout
    var logoutSuccess = true
    
    // Refresh token
    var refreshTokenSuccess = true
    
    func login(credential: [String : Any],
               success: @escaping (MockToken, MockUser?) -> Void,
               failure: @escaping (Error) -> Void) {
        register(.login)
        
        if loginSuccess {
            success(mockToken, mockUser)
        } else {
            failure(mockError)
        }
    }
    
    func logout(credential: [String : Any]?, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        register(.logout)
        
        if logoutSuccess {
            success?()
        } else {
            failure?(mockError)
        }
    }
    
    func refreshToken(refreshToken: String, success: @escaping (MockToken) -> Void, failure: @escaping (Error) -> Void) {
        register(.refreshToken(refreshToken: refreshToken))
        
        if refreshTokenSuccess {
            success(mockToken)
        } else {
            failure(mockError)
        }
    }
}
