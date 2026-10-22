//
//  FakeAuthService.swift
//  ArtSearchTests
//
//  Created by Avi Pogrow on 10/22/26.
//
@testable import ArtSearch

@MainActor
final class FakeAuthService: AuthService {
    var errorToThrow: AuthError?
    private(set) var logInCallCount = 0      // NEW: how many times logIn ran

    func logIn(email: String, password: String) async throws {
        logInCallCount += 1                  // NEW: count this call
        if let errorToThrow {
            throw errorToThrow
        }
    }
}
