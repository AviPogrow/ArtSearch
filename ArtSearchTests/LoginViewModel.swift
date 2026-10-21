//
//  LoginViewModel.swift
//  ArtSearchTests
//
//  Created by Avi Pogrow on 10/21/26.
//

import XCTest
@testable import ArtSearch

@MainActor
final class LoginViewModelTests: XCTestCase {

    // Test 1: easy
    func test_invalidEmail_cannotLogIn() {
        let vm = LoginViewModel()
        vm.send(.emailChanged("abc"))
        vm.send(.passwordChanged("password1"))

        XCTAssertFalse(vm.canLogIn)
    }
    // Test 2: naive
    func test_wrongPassword_showsError() {
        let vm = LoginViewModel()
        vm.send(.emailChanged("avi@example.com"))
        vm.send(.passwordChanged("password2"))
        vm.send(.logInTapped)

        XCTAssertEqual(vm.errorMessage, "Email or password is incorrect")
    }
    // Test 3: workaround
    func test_wrongPassword_showsError_afterWaiting() async throws {
        let vm = LoginViewModel()
        vm.send(.emailChanged("avi@example.com"))
        vm.send(.passwordChanged("password2"))
        vm.send(.logInTapped)

        try await Task.sleep(for: .seconds(1.5))

        XCTAssertEqual(vm.errorMessage, "Email or password is incorrect")
    }
    
}
