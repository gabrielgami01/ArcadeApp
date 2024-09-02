import SwiftUI

struct RegisterView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(\.dismiss) private var dismiss
    @State var registerVM = RegisterVM()
    
    @FocusState var fields: SignupFields?
    
    var body: some View {
        @Bindable var registerBVM = registerVM
        
        ScrollView {
            VStack(spacing: 40) {
                HStack{
                    CustomHeader(title: "Sign Up")
                    Spacer()
                }
                
                VStack(spacing: 25) {
                    CustomTextField(text: $registerBVM.fullName, label: "Full Name", capitalization: .words)
                        .textContentType(.name)
                        .focused($fields, equals: .fullName)
                    CustomTextField(text: $registerBVM.email, label: "Email")
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .focused($fields, equals: .email)
                    
                    CustomTextField(text: $registerBVM.username, label: "Username")
                        .textContentType(.username)
                        .focused($fields, equals: .username)
                    
                    CustomTextField(text: $registerBVM.password, label: "Password", type: .secured)
                        .textContentType(.password)
                        .focused($fields, equals: .password)
                    
                    CustomTextField(text: $registerBVM.repeatPassword, label: "Re-enter password", type: .secured)
                        .textContentType(.password)
                        .focused($fields, equals: .repeatPassword)
                }
                
                Button {
                    if registerVM.checkFields() {
                        registerVM.register()
                        userVM.username = registerVM.username
                        dismiss()
                    } else {
                        registerVM.showError.toggle()
                    }
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(CustomButtonStyle())
                .disabled(registerVM.checkEmptyFields())
            }
        }
        .showAlert(show: $registerBVM.showError, text: registerVM.errorMsg)
        .navigationBarBackButtonHidden()
        .padding()
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    RegisterView(registerVM: RegisterVM(interactor: TestInteractor()))
        .environment(UserVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}


