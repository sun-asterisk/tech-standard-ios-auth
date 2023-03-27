import XCTest
@testable import CredentialAuth

final class CredentialAuthTests: XCTestCase {
    private var credentialAuth: CredentialAuth!
    private var delegate: MockCredentialAuthDelegate!
    
    override func setUp() {
        super.setUp()
        credentialAuth = CredentialAuth()
    }
    
    func test_login_success() {
        let expectation = XCTestExpectation(description: "Login success")
        delegate = MockCredentialAuthDelegate(expected: [.login])
        delegate.mockToken = MockToken.stub
        delegate.mockUser = MockUser.stub
        credentialAuth.delegate = delegate
        
        credentialAuth.login(credential: [:]) { result in
            switch result {
            case .success:
                let token = self.credentialAuth.getToken()
                XCTAssertNotNil(token)
                
                let user = self.credentialAuth.getUser()
                XCTAssertNotNil(user)
            default:
                XCTAssert(false)
            }
            
            self.delegate.verify()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_login_failed() {
        let expectation = XCTestExpectation(description: "Login failed")
        delegate = MockCredentialAuthDelegate(expected: [.login])
        delegate.loginSuccess = false
        let mockError = MockError()
        delegate.mockError = mockError
        credentialAuth.delegate = delegate
        
        credentialAuth.login(credential: [:]) { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(error.isEqual(to: mockError))
                
                let token = self.credentialAuth.getToken()
                XCTAssertNil(token)
                
                let user = self.credentialAuth.getUser()
                XCTAssertNil(user)
            }
            
            self.delegate.verify()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_logout_success() {
        let expectation = XCTestExpectation(description: "Logout success")
        delegate = MockCredentialAuthDelegate(expected: [.logout])
        credentialAuth.delegate = delegate
        
        credentialAuth.logout(credential: nil) { result in
            switch result {
            case .success:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
            
            self.delegate.verify()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_logout_failed() {
        let expectation = XCTestExpectation(description: "Logout failed")
        delegate = MockCredentialAuthDelegate(expected: [.logout])
        delegate.logoutSuccess = false
        let mockError = MockError()
        delegate.mockError = mockError
        credentialAuth.delegate = delegate
        
        credentialAuth.logout(credential: nil) { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(error.isEqual(to: mockError))
            }
            
            self.delegate.verify()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
