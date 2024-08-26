import SwiftUI

struct LoginView: View {
    @Environment(UserVM.self) private var userVM
    
    @State private var asyncText = ""
    @State private var animationTF = false
    @State private var animationSU = false
    
    var body: some View {
        @Bindable var bvm = userVM
        
        NavigationStack {
            VStack(spacing: 80) {
                AsyncText(text: $asyncText, label: "WELCOME TO ARCADE STUDIOS", font: Font.customLargeTitle)
                
                VStack {
                    CustomTextField(value: $bvm.username, isError: $bvm.showError, label: "Username")
                        .textContentType(.username)
                       
                    CustomTextField(value: $bvm.password, isError: $bvm.showError, label: "Password", type: .secured)
                        .textContentType(.password)
                       
                    CustomButton(label: "Log In") {
                        userVM.login()
                    }
                }
                .offset(x: animationTF ? 0 : -300)
                .opacity(animationTF ? 1 : 0)
                
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
                .opacity(animationSU ? 1 : 0)
                
                Spacer()
            }
            .onAppear {
                withAnimation(.easeOut.delay(3)) {
                    animationTF = true
                } completion: {
                    withAnimation {
                        animationSU = true
                    }
                }
            }
            .navigationDestination(isPresented: $bvm.showSignup) {
                SignupView()
            }
            .padding()
            .background(Color.backgroundColor)
        }
    }
    
}

#Preview {
    LoginView()
        .environment(UserVM(interactor: TestInteractor()))
}
