import XCTest
@testable import CredentialAuth

final class CredentialAuthTests: XCTestCase {
    private var credentialAuth: CredentialAuth!
    private var delegate: MockCredentialAuthDelegate!
    
    override func setUp() {
        super.setUp()
        
        credentialAuth = CredentialAuth()
        delegate = MockCredentialAuthDelegate()
        credentialAuth.delegate = delegate
    }
    
    func test_login_success() {
        let expectation = XCTestExpectation(description: "Login success")
        
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
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_login_failed() {
        delegate.loginSuccess = false
        let expectation = XCTestExpectation(description: "Login failed")
        
        credentialAuth.login(credential: [:]) { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(error is MockError)
                
                let token = self.credentialAuth.getToken()
                XCTAssertNil(token)
                
                let user = self.credentialAuth.getUser()
                XCTAssertNil(user)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_logout_success() {
        let expectation = XCTestExpectation(description: "Logout success")
        
        credentialAuth.logout(credential: nil) { result in
            switch result {
            case .success:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_logout_failed() {
        delegate.logoutSuccess = false
        let expectation = XCTestExpectation(description: "Logout failed")
        
        credentialAuth.logout(credential: nil) { result in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(error is MockError)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
