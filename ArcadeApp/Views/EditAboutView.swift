import SwiftUI

struct EditAboutView: View {
    @Environment(UserVM.self) private var userVM
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        @Bindable var bvm = userVM
        
        NavigationStack {
            VStack {
                TextEditor(text: $bvm.about)
                    .scrollContentBackground(.hidden)
                    .font(.customBody)
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: 300, alignment: .top)
                
                Spacer()
            }
            .sheetToolbar(title: "About", confirmationLabel: "Save") {
                if await userVM.updateUserAboutAPI() {
                    userVM.updatedUserAbout()
                    dismiss()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .background(Color.background)
        }
        .onAppear {
            if let about = userVM.activeUser?.about {
                userVM.about = about
            }
        }
        
    }
}

#Preview {
    EditAboutView()
        .environment(UserVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}



