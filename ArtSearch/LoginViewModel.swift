//
//  LoginViewModel.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/20/26.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    // Stored: only the user knows these
    @Published var email = ""
    @Published var password = ""

    // Computed: worked out from the two above
    var isEmailValid: Bool {
        let parts = email.split(separator: "@")
        return parts.count == 2 && parts[1].contains(".")
    }

    var isPasswordValid: Bool {
        password.count >= 8
    }

    var canLogIn: Bool {
        isEmailValid && isPasswordValid
    }

    var emailMessage: String? {
        if email.isEmpty || isEmailValid { return nil }
        return "Enter an email like name@example.com"
    }

    var passwordMessage: String? {
        if password.isEmpty || isPasswordValid { return nil }
        return "At least 8 characters (\(password.count)/8)"
    }
}
