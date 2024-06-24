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
                .padding(.top, 40)
            VStack(spacing: 20) {
                CustomTextField(value: $bvm.fullName, label: "Full Name", type: .simple, capitalization: .words)
                    .textContentType(.name)
                    .focused($fields, equals: .fullName)
                CustomTextField(value: $bvm.email, label: "Email", type: .simple)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .focused($fields, equals: .email)
                CustomTextField(value: $bvm.username, label: "Username", type: .simple)
                    .textContentType(.username)
                    .focused($fields, equals: .username)
                CustomTextField(value: $bvm.password, label: "Password", type: .secured)
                    .textContentType(.password)
                    .focused($fields, equals: .password)
                CustomTextField(value: $bvm.repeatPassword, label: "Re-enter password", type: .secured)
                    .textContentType(.password)
                    .focused($fields, equals: .repeatPassword)
                CustomLoginButton(label: "Sign Up") {
                    loginVM.register()
                }
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
        .onAppear {
            loginVM.resetRegister()
        }
    }
}

#Preview {
    NavigationStack {
        SignupView()
            .environment(LoginVM())
    }
}


