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
    func test_invalidEmail_cannotLogIn() async {
        let vm = LoginViewModel(authService: FakeAuthService())
        vm.send(.emailChanged("abc"))
        vm.send(.passwordChanged("password1"))

        XCTAssertFalse(vm.canLogIn)
    }
    // Test 2: naive
    //func test_wrongPassword_showsError() {
     //   let vm = LoginViewModel()
     //   vm.send(.emailChanged("avi@example.com"))
      //  vm.send(.passwordChanged("password2"))
      //  vm.send(.logInTapped)

      //  XCTAssertEqual(vm.errorMessage, "Email or password is incorrect")
    //}
    
    // Test 2: with the fake, awaiting the login
    func test_wrongPassword_showsError() async {
        let fake = FakeAuthService()
        fake.errorToThrow = .invalidCredentials
        let vm = LoginViewModel(authService: fake)

        vm.send(.emailChanged("avi@example.com"))
        vm.send(.passwordChanged("anything1"))
        vm.send(.logInTapped)
        await vm.loginTask?.value

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
    
    func test_correctLogin_endsLoggedIn() async {
        let vm = LoginViewModel(authService: FakeAuthService())

        vm.send(.emailChanged("avi@example.com"))
        vm.send(.passwordChanged("anything1"))
        vm.send(.logInTapped)
        await vm.loginTask?.value

        XCTAssertEqual(vm.phase, .loggedIn)
    }

    func test_noNetwork_showsConnectionMessage() async {
        let fake = FakeAuthService()
        fake.errorToThrow = .network
        let vm = LoginViewModel(authService: fake)

        vm.send(.emailChanged("avi@example.com"))
        vm.send(.passwordChanged("anything1"))
        vm.send(.logInTapped)
        await vm.loginTask?.value

        XCTAssertEqual(vm.errorMessage, "Can't reach the server. Check your connection.")
    }

    func test_editingAfterFailure_clearsError() async {
        let fake = FakeAuthService()
        fake.errorToThrow = .invalidCredentials
        let vm = LoginViewModel(authService: fake)

        vm.send(.emailChanged("avi@example.com"))
        vm.send(.passwordChanged("anything1"))
        vm.send(.logInTapped)
        await vm.loginTask?.value

        vm.send(.passwordChanged("anything12"))

        XCTAssertEqual(vm.phase, .idle)
    }

    func test_doubleTap_logsInOnlyOnce() async {
        let fake = FakeAuthService()
        let vm = LoginViewModel(authService: fake)

        vm.send(.emailChanged("avi@example.com"))
        vm.send(.passwordChanged("anything1"))
        vm.send(.logInTapped)
        vm.send(.logInTapped)   // second tap, while logging in
        await vm.loginTask?.value

        XCTAssertEqual(fake.logInCallCount, 1)
    }
    
}
