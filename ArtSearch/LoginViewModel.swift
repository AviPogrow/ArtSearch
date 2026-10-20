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
    // Stored: only the user knows these
    @Published var email = ""
    @Published var password = ""
    
    // published so that the view can subscribe to changes
    // private so that the view cannot write any changes only
    // view model can
    // .idle is the starting phase
    @Published private(set) var phase: LoginPhase = .idle   // NEW

    
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
        // reset the enum to a new loggin in state
        // and we can write a new enum value because
        // we are inside the view model
        phase = .loggingIn
    }
}
