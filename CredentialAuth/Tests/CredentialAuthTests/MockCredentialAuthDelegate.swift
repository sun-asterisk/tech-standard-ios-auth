import XCTest
@testable import CredentialAuth

final class MockCredentialAuthDelegate: CredentialAuthDelegate {
    // Login
    var loginCalled = false
    var loginSuccess = true
    var mockToken = MockToken()
    var mockUser = MockUser()
    var mockError = MockError()
    
    // Logout
    var logoutCalled = false
    var logoutSuccess = true
    
    // Refresh token
    var refreshTokenCalled = false
    var refreshTokenSuccess = true
    
    func login(credential: [String : Any],
               success: @escaping (MockToken, MockUser?) -> Void,
               failure: @escaping (Error) -> Void) {
        loginCalled = true
        
        if loginSuccess {
            success(mockToken, mockUser)
        } else {
            failure(mockError)
        }
    }
    
    func logout(credential: [String : Any]?, success: (() -> Void)?, failure: ((Error) -> Void)?) {
       loginCalled = true
        
        if logoutSuccess {
            success?()
        } else {
            failure?(mockError)
        }
    }
    
    func refreshToken(refreshToken: String, success: @escaping (MockToken) -> Void, failure: @escaping (Error) -> Void) {
        refreshTokenCalled = true
        
        if refreshTokenSuccess {
            success(mockToken)
        } else {
            failure(mockError)
        }
    }
}
