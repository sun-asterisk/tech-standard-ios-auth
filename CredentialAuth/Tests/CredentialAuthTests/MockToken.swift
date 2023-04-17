import CredentialAuth
import Foundation

struct MockToken: AuthToken, Codable {
    var id = UUID().uuidString
    var accessToken = ""
    var refreshToken = ""
    var expiredDate = Date()
}

extension MockToken {
    func save(key: String) throws {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func get(key: String) -> MockToken? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return try? JSONDecoder().decode(MockToken.self, from: data)
    }
    
    static func remove(key: String) throws {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

extension MockToken {
    static let stub = MockToken(id: "1",
                                accessToken: "access token",
                                refreshToken: "refresh token",
                                expiredDate: Date())
}
