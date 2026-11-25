import SwiftUI
import SwiftData

struct AuthenticationView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel = AuthenticationViewModel()

    @State private var biometricError = ""

    private let biometricService = BiometricService()
    private let authenticationService = AuthenticationService()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 22) {

                    Spacer(minLength: 30)

                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)

                    Text("Investment Portfolio")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text(
                        viewModel.isSignUp
                        ? "Create your account"
                        : "Welcome back"
                    )
                    .font(.title3)
                    .foregroundStyle(.secondary)

                    VStack(spacing: 15) {

                        if viewModel.isSignUp {

                            TextField(
                                "Full Name",
                                text: $viewModel.name
                            )
                            .textContentType(.name)
                            .textFieldStyle(.roundedBorder)
                        }

                        TextField(
                            "Email Address",
                            text: $viewModel.email
                        )
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.emailAddress)
                        .textFieldStyle(.roundedBorder)

                        SecureField(
                            "Password",
                            text: $viewModel.password
                        )
                        .textContentType(
                            viewModel.isSignUp
                            ? .newPassword
                            : .password
                        )
                        .textFieldStyle(.roundedBorder)

                        if viewModel.isSignUp {

                            SecureField(
                                "Confirm Password",
                                text: $viewModel.confirmPassword
                            )
                            .textContentType(.newPassword)
                            .textFieldStyle(.roundedBorder)
                        }
                    }

                    if !viewModel.errorMessage.isEmpty {

                        Text(viewModel.errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    if !biometricError.isEmpty {

                        Text(biometricError)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button {

                        if viewModel.isSignUp {

                            viewModel.register(
                                context: context,
                                appState: appState
                            )

                        } else {

                            viewModel.login(
                                context: context,
                                appState: appState
                            )
                        }

                    } label: {

                        Text(
                            viewModel.isSignUp
                            ? "Create Account"
                            : "Login"
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                    }

                    if !viewModel.isSignUp {

                        Button {

                            Task {
                                await loginWithBiometrics()
                            }

                        } label: {

                            Label(
                                "Login with Face ID",
                                systemImage: "faceid"
                            )
                            .font(.headline)
                        }
                    }

                    HStack(spacing: 5) {

                        Text(
                            viewModel.isSignUp
                            ? "Already have an account?"
                            : "Don't have an account?"
                        )
                        .foregroundStyle(.secondary)

                        Button {

                            biometricError = ""

                            if viewModel.isSignUp {
                                viewModel.switchToLogin()
                            } else {
                                viewModel.switchToSignUp()
                            }

                        } label: {

                            Text(
                                viewModel.isSignUp
                                ? "Login"
                                : "Sign Up"
                            )
                            .fontWeight(.semibold)
                        }
                    }

                    Spacer(minLength: 30)
                }
                .padding(25)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    @MainActor
    private func loginWithBiometrics() async {

        do {

            let user = try authenticationService.lastLoggedInUser(
                context: context
            )

            try await biometricService.authenticate()

            biometricError = ""

            appState.login(
                name: user.name,
                email: user.email
            )

        } catch {

            biometricError = error.localizedDescription +
                " Please use your email and password."
        }
    }
}
