import SwiftUI

struct LoginView: View {
    @Environment(LoginVM.self) private var loginVM
    
    var body: some View {
        @Bindable var bvm = loginVM
        
        NavigationStack {
            VStack {
                Text("Arcade Studio")
                    .font(.largeTitle)
                    .bold()
                VStack (spacing: 20){
                    CustomTextField(value: $bvm.username, label: "Username", type: .simple)
                        .textContentType(.username)
                    CustomTextField(value: $bvm.password, label: "Password", type: .secured)
                        .textContentType(.password)
                    CustomLoginButton(label: "Log In") {
                        loginVM.login()
                    }
                }
                .padding(.vertical, 100)
                HStack {
                    Text("Don't have an account?")
                    Button {
                        loginVM.showSignup.toggle()
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
        .environment(LoginVM())
}
