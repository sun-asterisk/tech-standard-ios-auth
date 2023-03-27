import Foundation

struct MockUser: Codable {
    var id = UUID().uuidString
    var name = ""
}

extension MockUser {
    static let stub = MockUser(name: "Mock user")
}

