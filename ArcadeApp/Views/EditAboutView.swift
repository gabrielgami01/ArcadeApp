import SwiftUI

struct EditAboutView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        @Bindable var bvm = userVM
        
        NavigationStack {
            ScrollView {
                VStack {
                    TextEditor(text: $bvm.about)
                        .scrollContentBackground(.hidden)
                        .font(.customBody)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 300, alignment: .top)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheetToolbar(title: "About", confirmationLabel: "Save") {
                userVM.editUserAbout()
                dismiss()
            }
            .padding()
            .scrollBounceBehavior(.basedOnSize)
            .background(Color.background)
        }
        .onAppear {
            if let about = userVM.activeUser?.biography {
                userVM.about = about 
            }
        }
        
    }
}

#Preview {
    EditAboutView()
        .environment(UserVM(interactor: TestInteractor()))
}



