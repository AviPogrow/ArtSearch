//
//  LoginViewModel.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/20/26.
//

import Foundation
import Combine

// NEW
enum LoginPhase {
    case idle
    case loggingIn
    case failed(String)
    case loggedIn
}

final class LoginViewModel: ObservableObject {
    
    // as user types email ..this property
    // gets reset and if wee are in a failed
    // state we reste the  state to idle
    // that moves us out of the .failed(message)
    // so the  old error message returns nil
    // so when the view redraws it checks if error message is nil
    //   if let message = viewModel.errorMessage {
    //Text(message)
    @Published var email = "" {
        didSet { clearFailure() }
    }

    @Published var password = "" {
        didSet { clearFailure() }
    }
    
    // published so that the view can subscribe to changes
    // private so that the view cannot write any changes only
    // view model can
    // .idle is the starting phase
    @Published private(set) var phase: LoginPhase = .idle   // NEW

    private func clearFailure() {
        if case .failed = phase {
            phase = .idle
        }
    }
    
    var isLoggingIn: Bool {
        // ask the login phase enum what state its in
        // if its .logginIn return true
        if case .loggingIn = phase { return true }
        return false
    }
    
    // Computed: worked out from the two above
    var isEmailValid: Bool {
        let parts = email.split(separator: "@")
        return parts.count == 2 && parts[1].contains(".")
    }

    var isPasswordValid: Bool {
        password.count >= 8
    }

    var canLogIn: Bool {
        isEmailValid && isPasswordValid && isLoggingIn == false
    }

    var emailMessage: String? {
        if email.isEmpty || isEmailValid { return nil }
        return "Enter an email like name@example.com"
    }

    var passwordMessage: String? {
        if password.isEmpty || isPasswordValid { return nil }
        return "At least 8 characters (\(password.count)/8)"
    }
    
    func logInTapped() {
        // check the computed proprty canLoginIn
        // which itself checks three things
        // form inputs valid and ...
        // reads the phase enum
        // to see if it already is in the logging in state
        guard canLogIn else { return }
        phase = .loggingIn

        // TEMPORARY: pretend answer until A5
        // Task creates a new context that allows us
        // to create async call
        Task {
            
            // the parent function "loginTapped"
            // continues and returns while this
            // function call waits
            // sleep can be cancelled so we call try?
            //
            try? await Task.sleep(for: .seconds(1))

            
            // reset the enum to a new loggin in state
            // and we can write a new enum value because
            // we are inside the view model
            if password == "password1" {
                phase = .loggedIn
            } else {
                phase = .failed("Email or password is incorrect")
            }
            // the print tells us which phase we landed in
            print("Phase is now: \(phase)")
        }
    }
    
    // if the phase is failed then extract the text inside it
    // and call it "message"
    // if we move out of the failed state
    // error message becomes nil
    var errorMessage: String? {
        if case .failed(let message) = phase { return message }
        return nil
    }
}

