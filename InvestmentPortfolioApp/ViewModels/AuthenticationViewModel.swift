import Foundation
import SwiftData
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {

    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var errorMessage = ""
    @Published var isSignUp = false

    private let authenticationService = AuthenticationService()

    func register(
        context: ModelContext,
        appState: AppState
    ) {

        do {

            let user = try authenticationService.signUp(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                context: context
            )

            errorMessage = ""

            appState.login(
                name: user.name,
                email: user.email
            )

        } catch {

            errorMessage = error.localizedDescription
        }
    }

    func login(
        context: ModelContext,
        appState: AppState
    ) {

        do {

            let user = try authenticationService.login(
                email: email,
                password: password,
                context: context
            )

            errorMessage = ""

            appState.login(
                name: user.name,
                email: user.email
            )

        } catch {

            errorMessage = error.localizedDescription
        }
    }

    func switchToSignUp() {
        isSignUp = true
        errorMessage = ""
        password = ""
        confirmPassword = ""
    }

    func switchToLogin() {
        isSignUp = false
        errorMessage = ""
        password = ""
        confirmPassword = ""
    }
}
