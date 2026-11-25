import Foundation
import SwiftData

@Model
final class AppUser {

    @Attribute(.unique) var email: String

    var name: String
    var passwordHash: String
    var passwordSalt: String

    init(
        name: String,
        email: String,
        passwordHash: String,
        passwordSalt: String
    ) {
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.passwordSalt = passwordSalt
    }
}
