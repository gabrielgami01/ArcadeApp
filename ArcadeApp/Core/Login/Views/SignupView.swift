//
//  SignupView.swift
//  ArcadeApp
//
//  Created by Gabriel Garcia Millan on 21/6/24.
//

import SwiftUI

struct SignupView: View {
    @Environment(LoginVM.self) private var loginVM
    
    @FocusState var fields: SignupFields?
    
    var body: some View {
        @Bindable var bvm = loginVM
        
        ScrollView {
            Text("Sign up")
                .font(.title)
                .bold()
            VStack {
                CustomTextField(value: $bvm.fullName, isError: $bvm.showError,
                                label: "Full Name", type: .simple, capitalization: .words, validation: loginVM.fullNameValidation)
                    .textContentType(.name)
                    .focused($fields, equals: .fullName)
                CustomTextField(value: $bvm.email, isError: $bvm.showError,
                                label: "Email", type: .simple, validation: loginVM.emailValidation)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .focused($fields, equals: .email)
                CustomTextField(value: $bvm.username, isError: $bvm.showError,
                                label: "Username", type: .simple, validation: loginVM.usernameValidation)
                    .textContentType(.username)
                    .focused($fields, equals: .username)
                CustomTextField(value: $bvm.password, isError: $bvm.showError,
                                label: "Password", type: .secured, validation: loginVM.passwordValidation)
                    .textContentType(.password)
                    .focused($fields, equals: .password)
                CustomTextField(value: $bvm.repeatPassword, isError: $bvm.showError,
                                label: "Re-enter password", type: .secured, validation: loginVM.repeatPasswordValidation)
                    .textContentType(.password)
                    .focused($fields, equals: .repeatPassword)
                CustomLoginButton(label: "Sign Up") {
                    loginVM.register()
                    loginVM.showSignup.toggle()
                }
                .disabled(loginVM.enableSignupButton())
            }
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    loginVM.resetRegister()
                    loginVM.showSignup.toggle()
                } label: {
                    Text("Cancel")
                        .bold()
                }
            }
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button {
                        fields?.next()
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    Button {
                        fields?.prev()
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    Spacer()
                    Button{
                        fields = nil
                    } label: {
                        Image(systemName: "keyboard")
                }
                }
            }
        }
        .safeAreaPadding()
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    NavigationStack {
        SignupView()
            .environment(LoginVM())
    }
}


