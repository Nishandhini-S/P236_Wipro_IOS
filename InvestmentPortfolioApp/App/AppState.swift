import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {

    @Published var isAuthenticated = false
    @Published var currentUserName = ""
    @Published var currentUserEmail = ""

    func login(name: String, email: String) {
        currentUserName = name
        currentUserEmail = email.lowercased()
        isAuthenticated = true
    }

    func logout() {
        isAuthenticated = false
        currentUserName = ""
        currentUserEmail = ""
    }
}
