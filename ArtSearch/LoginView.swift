import SwiftUI

struct LoginView: View {
   
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("ArtSearch")
                .font(.largeTitle.bold())

            // NEW: field and its message grouped together
            VStack(alignment: .leading, spacing: 6) {
                TextField("Email", text: $viewModel.email)
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
                if let message =  viewModel.emailMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            // NEW: same for the password
            VStack(alignment: .leading, spacing: 6) {
                SecureField("Password", text: $viewModel.password)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                    )

                // if password message is not nil
                // then add text view and display the message else don't show it
                if let message =  viewModel.passwordMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            Button("Log in") {
                print("Log in tapped: \(viewModel.email)")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.canLogIn)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
