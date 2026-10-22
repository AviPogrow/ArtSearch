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

    func logIn(email: String, password: String) async throws {
        if let errorToThrow {
            throw errorToThrow
        }
    }
}
