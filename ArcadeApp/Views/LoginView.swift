import SwiftUI

struct LoginView: View {
    @Environment(UserVM.self) private var userVM
    
    var body: some View {
        @Bindable var bvm = userVM
        
        NavigationStack {
            ScrollView {
                AsyncText(label: "ARCADE STUDIOS", font: .customLargeTitle)
                
                VStack {
                    CustomTextField(value: $bvm.username, isError: $bvm.showError, label: "Username")
                        .textContentType(.username)
                    CustomTextField(value: $bvm.password, isError: $bvm.showError, label: "Password", type: .secured)
                        .textContentType(.password)
                    CustomButton(label: "Log In") {
                        userVM.login()
                    }
                }
                .padding(.vertical, 50)
                HStack {
                    Text("Don't have an account?")
                        .font(.customBody)
                    Button {
                        userVM.resetRegister()
                        userVM.showSignup.toggle()
                    } label: {
                        Text("Sign up")
                            .font(.customHeadline)
                    }
                }
            }
            .navigationDestination(isPresented: $bvm.showSignup) {
                SignupView()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environment(UserVM())
}
