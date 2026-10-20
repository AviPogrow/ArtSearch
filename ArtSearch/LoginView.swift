import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    // computed property to see if email is valid
    private var isEmailValid: Bool {
        // split the string
        let parts = email.split(separator: "@")
        // check there are 2 parts and the second
        // has an .
        return parts.count == 2 && parts[1].contains(".")
    }

    // check if password is valid if it
    // has more than 8 characters
    private var isPasswordValid: Bool {
        password.count >= 8
    }

    // computed property that checks both email and password
    private var canLogIn: Bool {
        isEmailValid && isPasswordValid
    }

    // NEW: messages, nil when there's nothing to say
    private var emailMessage: String? {
        if email.isEmpty || isEmailValid { return nil }
        return "Enter an email like name@example.com"
    }

    private var passwordMessage: String? {
        if password.isEmpty || isPasswordValid { return nil }
        return "At least 8 characters (\(password.count)/8)"
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("ArtSearch")
                .font(.largeTitle.bold())

            // NEW: field and its message grouped together
            VStack(alignment: .leading, spacing: 6) {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                    )

            // if email message is not nil
            // then add the textView with message
            // to the view
            // with the message
            // else remove the message view
            if let emailMessage {
                    Text(emailMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            // NEW: same for the password
            VStack(alignment: .leading, spacing: 6) {
                SecureField("Password", text: $password)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                    )

                // if password message is not nil
                // then add text view and display the message else don't show it
                if let passwordMessage {
                    Text(passwordMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            Button("Log in") {
                print("Log in tapped: \(email)")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canLogIn)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
