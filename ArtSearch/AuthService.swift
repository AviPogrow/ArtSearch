//
//  AuthService.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/22/26.
//

import Foundation

enum AuthError: Error {
    case invalidCredentials
    case network
}

protocol AuthService {
    func logIn(email: String, password: String) async throws
}

// The app's pretend backend, until there's a real server
struct DemoAuthService: AuthService {
    func logIn(email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(1))
        guard password == "password1" else {
            throw AuthError.invalidCredentials
        }
    }
}
