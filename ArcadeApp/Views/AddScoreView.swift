import SwiftUI

struct AddScoreView: View {
    @Environment(\.dismiss) private var dismiss
    @State var addScoreVM: AddScoreVM
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    CustomButton(label: "Send") {
                        
                    }
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
        }
    }
}

#Preview {
    AddScoreView(addScoreVM: AddScoreVM(game: .test))
}
