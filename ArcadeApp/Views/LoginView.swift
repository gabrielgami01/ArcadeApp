import SwiftUI

struct LoginView: View {
    @Environment(UserVM.self) private var userVM
    
    var body: some View {
        @Bindable var bvm = userVM
        
        NavigationStack {
            ScrollView {
                Text("Arcade Studio")
                    .font(.largeTitle)
                    .bold()
                VStack {
                    CustomTextField(value: $bvm.username, isError: $bvm.showError, label: "Username")
                        .textContentType(.username)
                    CustomTextField(value: $bvm.password, isError: $bvm.showError, label: "Password", type: .secured)
                        .textContentType(.password)
                    CustomButton(label: "Log In") {
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
            .background(Color("backgroundColor"))
            .safeAreaPadding()
            
        }
    }
}

#Preview {
    LoginView()
        .environment(UserVM())
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
