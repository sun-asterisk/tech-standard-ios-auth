import CredentialAuth
import Foundation

struct MockToken: AuthToken {
    var accessToken = ""
    var refreshToken = ""
    var expiredDate = Date()
}
