import SwiftUI
import PhotosUI

struct AddScoreView: View {
    @Environment(\.dismiss) private var dismiss
    @State var addScoreVM: AddScoreVM
    @State private var showCamera = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    addScoreVM.showCamera.toggle()
                } label: {
                    ScoreImage(image: addScoreVM.image)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .sheetToolbar(title: "Add new Score", confirmationLabel: "Save") {
                addScoreVM.addScore()
                dismiss()
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(photo: $addScoreVM.image)
            }
            .showAlert(show: $addScoreVM.showError, text: addScoreVM.errorMsg)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.backgroundGradient)
            
        }
    }
}

#Preview {
    AddScoreView(addScoreVM: AddScoreVM(game: .test, interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
