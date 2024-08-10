import SwiftUI
import PhotosUI

struct AddScoreView: View {
    @Environment(\.dismiss) private var dismiss
    @State var addScoreVM: AddScoreVM
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button {
                        addScoreVM.showCamera.toggle()
                    } label: {
                        ScoreImage(image: addScoreVM.image)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheetToolbar(title: "Add new score", confirmationLabel: "Send") {
                addScoreVM.addScore()
                dismiss()
            }
            .padding()
            .scrollBounceBehavior(.basedOnSize)
            .sheet(isPresented: $addScoreVM.showCamera) {
                CameraPicker(photo: $addScoreVM.image)
            }
            .background(Color.background)
        }
    }
}

#Preview {
    AddScoreView(addScoreVM: AddScoreVM(game: .test))
}
