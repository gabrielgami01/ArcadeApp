import SwiftUI

struct SignupView: View {
    @Environment(UserVM.self) private var userVM
    @FocusState var fields: SignupFields?
    
    var body: some View {
        @Bindable var bvm = userVM
        
        ScrollView {
            Text("Sign up")
                .font(.customTitle)
                .bold()
            VStack {
                CustomTextField(value: $bvm.fullName, isError: $bvm.showError,
                                label: "Full Name", capitalization: .words, validation: userVM.fullNameValidation)
                    .textContentType(.name)
                    .focused($fields, equals: .fullName)
                CustomTextField(value: $bvm.email, isError: $bvm.showError,
                                label: "Email", validation: userVM.emailValidation)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .focused($fields, equals: .email)
                CustomTextField(value: $bvm.username, isError: $bvm.showError,
                                label: "Username", validation: userVM.usernameValidation)
                    .textContentType(.username)
                    .focused($fields, equals: .username)
                CustomTextField(value: $bvm.password, isError: $bvm.showError,
                                label: "Password", type: .secured, validation: userVM.passwordValidation)
                    .textContentType(.password)
                    .focused($fields, equals: .password)
                CustomTextField(value: $bvm.repeatPassword, isError: $bvm.showError,
                                label: "Re-enter password", type: .secured, validation: userVM.repeatPasswordValidation)
                    .textContentType(.password)
                    .focused($fields, equals: .repeatPassword)
                CustomButton(label: "Sign Up") {
                    userVM.register()
                    userVM.showSignup.toggle()
                }
                .disabled(userVM.enableSignupButton())
            }
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    userVM.resetRegister()
                    userVM.showSignup.toggle()
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
            .environment(UserVM())
    }
}


