import Foundation
import LocalAuthentication

@MainActor
final class BiometricService {

    func authenticate() async throws {

        let context = LAContext()
        context.localizedCancelTitle = "Use Password"

        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            throw error ?? NSError(
                domain: "BiometricAuthentication",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Face ID is not enrolled or is unavailable."
                ]
            )
        }

        try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to access your investment portfolio."
        )
    }
}
