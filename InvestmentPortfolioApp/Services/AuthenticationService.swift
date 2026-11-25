import Foundation
import SwiftData
import CryptoKit

enum AuthenticationError: LocalizedError {

    case invalidName
    case invalidEmail
    case shortPassword
    case passwordMismatch
    case accountAlreadyExists
    case accountNotFound
    case incorrectPassword
    case noPreviousAccount

    var errorDescription: String? {

        switch self {

        case .invalidName:
            return "Please enter your name."

        case .invalidEmail:
            return "Please enter a valid email address."

        case .shortPassword:
            return "Password must contain at least 6 characters."

        case .passwordMismatch:
            return "Passwords do not match."

        case .accountAlreadyExists:
            return "An account with this email already exists."

        case .accountNotFound:
            return "No account found. Please sign up first."

        case .incorrectPassword:
            return "Incorrect password. Please try again."

        case .noPreviousAccount:
            return "Please log in using your email and password first."
        }
    }
}

@MainActor
final class AuthenticationService {

    private let lastEmailKey = "InvestmentPortfolio.lastLoggedInEmail"

    func signUp(
        name: String,
        email: String,
        password: String,
        confirmPassword: String,
        context: ModelContext
    ) throws -> AppUser {

        let cleanName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).lowercased()

        guard !cleanName.isEmpty else {
            throw AuthenticationError.invalidName
        }

        guard cleanEmail.contains("@"),
              cleanEmail.contains(".") else {
            throw AuthenticationError.invalidEmail
        }

        guard password.count >= 6 else {
            throw AuthenticationError.shortPassword
        }

        guard password == confirmPassword else {
            throw AuthenticationError.passwordMismatch
        }

        let emailToCheck = cleanEmail

        let descriptor = FetchDescriptor<AppUser>(
            predicate: #Predicate { user in
                user.email == emailToCheck
            }
        )

        let existingUsers = try context.fetch(descriptor)

        guard existingUsers.isEmpty else {
            throw AuthenticationError.accountAlreadyExists
        }

        let salt = UUID().uuidString

        let hash = Self.hashPassword(
            password,
            salt: salt
        )

        let newUser = AppUser(
            name: cleanName,
            email: cleanEmail,
            passwordHash: hash,
            passwordSalt: salt
        )

        context.insert(newUser)
        try context.save()

        UserDefaults.standard.set(
            cleanEmail,
            forKey: lastEmailKey
        )

        return newUser
    }

    func login(
        email: String,
        password: String,
        context: ModelContext
    ) throws -> AppUser {

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).lowercased()

        let emailToCheck = cleanEmail

        let descriptor = FetchDescriptor<AppUser>(
            predicate: #Predicate { user in
                user.email == emailToCheck
            }
        )

        let users = try context.fetch(descriptor)

        guard let user = users.first else {
            throw AuthenticationError.accountNotFound
        }

        let enteredHash = Self.hashPassword(
            password,
            salt: user.passwordSalt
        )

        guard enteredHash == user.passwordHash else {
            throw AuthenticationError.incorrectPassword
        }

        UserDefaults.standard.set(
            cleanEmail,
            forKey: lastEmailKey
        )

        return user
    }

    func lastLoggedInUser(
        context: ModelContext
    ) throws -> AppUser {

        guard let email = UserDefaults.standard.string(
            forKey: lastEmailKey
        ), !email.isEmpty else {
            throw AuthenticationError.noPreviousAccount
        }

        let emailToFind = email

        let descriptor = FetchDescriptor<AppUser>(
            predicate: #Predicate { user in
                user.email == emailToFind
            }
        )

        let users = try context.fetch(descriptor)

        guard let user = users.first else {
            throw AuthenticationError.accountNotFound
        }

        return user
    }

    func hasAccount(context: ModelContext) -> Bool {

        do {
            let users = try context.fetch(
                FetchDescriptor<AppUser>()
            )

            return !users.isEmpty

        } catch {
            return false
        }
    }

    private static func hashPassword(
        _ password: String,
        salt: String
    ) -> String {

        let input = salt + password
        let digest = SHA256.hash(data: Data(input.utf8))

        return digest.map {
            String(format: "%02x", $0)
        }.joined()
    }
}
