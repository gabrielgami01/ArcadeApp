import SwiftUI

struct LoginView: View {
    @Environment(UserVM.self) private var userVM
    
    @State private var showRegister = false
    
    @State private var asyncText = ""
    @State private var animationTF = false
    @State private var animationSU = false
    
    var body: some View {
        @Bindable var userBVM = userVM
        
        NavigationStack {
            VStack(spacing: 40) {
                AsyncText(text: $asyncText, label: "Arcade Studios", font: .customExtraLargeTitle)
                
                VStack(spacing: 20) {
                    CustomTextField(text: $userBVM.username, label: "Username")
                        .textContentType(.username)
                    
                    CustomTextField(text: $userBVM.password, label: "Password", type: .secured)
                        .textContentType(.password)
                    
                    Button {
                        Task {
                            await userVM.login()
                            userVM.password.removeAll()
                        }
                        
                    } label: {
                        Text("Log In")
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(userVM.checkEmptyFields())
                }
                .offset(x: animationTF ? 0.0 : -UIDevice.width)
                .opacity(animationTF ? 1 : 0.0)
                
                HStack {
                    Text("Don't have an account?")
                        
                    Button {
                        showRegister = true
                        userVM.resetLogin()
                    } label: {
                        Text("Sign up")
                    }
                }
                .font(.customBody)
                .opacity(animationSU ? 1.0 : 0.0)
                
                Spacer()
            }
            .onAppear {
                withAnimation(.easeOut.delay(1.55)) {
                    animationTF = true
                } completion: {
                    withAnimation(.easeOut) {
                        animationSU = true
                    }
                }
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
            .padding(.horizontal)
            .padding(.top, 100)
            .background(Color.background)
            .showAlert(show: $userBVM.showError, text: userVM.errorMsg)
        }
    }
}

#Preview {
    LoginView()
        .environment(UserVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

