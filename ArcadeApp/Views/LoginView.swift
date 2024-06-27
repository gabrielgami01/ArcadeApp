import SwiftUI

struct LoginView: View {
    @Environment(UserVM.self) private var userVM
    
    var body: some View {
        @Bindable var bvm = userVM
        
        NavigationStack {
            VStack {
                Text("Arcade Studio")
                    .font(.largeTitle)
                    .bold()
                VStack (){
                    CustomTextField(value: $bvm.username, isError: $bvm.showError, label: "Username", type: .simple)
                        .textContentType(.username)
                    CustomTextField(value: $bvm.password, isError: $bvm.showError, label: "Password", type: .secured)
                        .textContentType(.password)
                    CustomLoginButton(label: "Log In") {
                        userVM.login()
                    }
                }
                .padding(.vertical, 100)
                HStack {
                    Text("Don't have an account?")
                    Button {
                        userVM.resetRegister()
                        userVM.showSignup.toggle()
                    } label: {
                        Text("Sign up")
                    }
                }
            }
            .navigationDestination(isPresented: $bvm.showSignup) {
                SignupView()
            }
            .safeAreaPadding()
        }
    }
}

#Preview {
    LoginView()
        .environment(UserVM())
}