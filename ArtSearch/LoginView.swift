//
//  LoginView.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/19/26.
//
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("ArtSearch")
                .font(.largeTitle.bold())

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

            SecureField("Password", text: $password)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                )

            Button("Log in") {
                print("Log in tapped: \(email)")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
