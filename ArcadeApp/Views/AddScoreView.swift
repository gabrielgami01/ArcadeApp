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
                    
                    CustomButton(label: "Send") {
                        addScoreVM.addScore()
                    }
                    .disabled(addScoreVM.image == nil ? true : false)
                }
                
            }
            .navigationTitle("Add new score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
            }
            .padding()
            .scrollBounceBehavior(.basedOnSize)
            .sheet(isPresented: $addScoreVM.showCamera) {
                CameraPicker(photo: $addScoreVM.image)
            }
        }
    }
}

#Preview {
    AddScoreView(addScoreVM: AddScoreVM(game: .test))
}
