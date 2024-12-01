import SwiftUI
import PhotosUI

struct AddScoreView: View {
    @State private var addScoreVM = AddScoreVM()
    
    let game: Game
    @State var detailsVM: GameDetailsVM
    
    @State private var showCamera = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    showCamera = true
                } label: {
                    ScoreImage(image: addScoreVM.image)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .sheetToolbar(title: "Add new score", confirmationLabel: "Save") {
                if let (score, imageData) = addScoreVM.newScore() {
                    if await detailsVM.addScoreAPI(imageData: imageData, to: game) {
                        detailsVM.addScore(score)
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(photo: $addScoreVM.image)
            }
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity)
            .background(Color.background)
        }
    }
}

#Preview {
    AddScoreView(game: .test, detailsVM: GameDetailsVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
