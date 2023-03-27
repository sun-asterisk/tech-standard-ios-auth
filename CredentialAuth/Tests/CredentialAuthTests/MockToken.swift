import CredentialAuth
import Foundation

struct MockToken: AuthToken {
    var id = UUID().uuidString
    var accessToken = ""
    var refreshToken = ""
    var expiredDate = Date()
}

extension MockToken {
    static let stub = MockToken(id: "1",
                                accessToken: "access token",
                                refreshToken: "refresh token",
                                expiredDate: Date())
}
