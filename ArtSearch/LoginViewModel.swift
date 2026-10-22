//
//  LoginViewModel.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/20/26.
//

import Foundation
import Combine

enum LoginPhase: Equatable {
    case idle
    case loggingIn
    case failed(String)
    case loggedIn
}

enum LoginIntent {
    case emailChanged(String)
    case passwordChanged(String)
    case logInTapped
}

final class LoginViewModel: ObservableObject {
    // State
    @Published private(set) var email = ""
    @Published private(set) var password = ""
    @Published private(set) var phase: LoginPhase = .idle
    
    private(set) var loginTask: Task<Void, Never>?
    
    private let authService: any AuthService

    init(authService: any AuthService = DemoAuthService()) {
        self.authService = authService
    }

    // Rules that read the input
    var isEmailValid: Bool {
        let parts = email.split(separator: "@")
        return parts.count == 2 && parts[1].contains(".")
    }

    var isPasswordValid: Bool {
        password.count >= 8
    }

    var emailMessage: String? {
        if email.isEmpty || isEmailValid { return nil }
        return "Enter an email like name@example.com"
    }

    var passwordMessage: String? {
        if password.isEmpty || isPasswordValid { return nil }
        return "At least 8 characters (\(password.count)/8)"
    }

    // Rules that read the phase
    var isLoggingIn: Bool {
        if case .loggingIn = phase { return true }
        return false
    }

    var errorMessage: String? {
        if case .failed(let message) = phase { return message }
        return nil
    }

    // Rule that reads both
    var canLogIn: Bool {
        isEmailValid && isPasswordValid && !isLoggingIn
    }

    // The one door
    func send(_ intent: LoginIntent) {
        switch intent {
        case .emailChanged(let text):
            email = text
            clearFailure()
        case .passwordChanged(let text):
            password = text
            clearFailure()
        case .logInTapped:
            logIn()
        }
    }

    // Rules that change the phase
    private func logIn() {
        guard canLogIn else { return }
        phase = .loggingIn

        loginTask = Task {
            do {
                try await authService.logIn(email: email, password: password)
                phase = .loggedIn
            } catch AuthError.network {
                phase = .failed("Can't reach the server. Check your connection.")
            } catch {
                phase = .failed("Email or password is incorrect")
            }
        }
    }
    
    private func clearFailure() {
        if case .failed = phase {
            phase = .idle
        }
    }
}
