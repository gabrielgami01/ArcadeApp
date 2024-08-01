import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State var addReviewVM: AddReviewVM
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    CustomTextField(value: $addReviewVM.title, isError: $addReviewVM.showAlert, label: "Title")
                    HStack(spacing: 40) {
                        Text("Rating")
                            .font(.customBody)
                            .bold()
                        RatingComponent(rating: $addReviewVM.rating, mode: .rate)
                    }
                    .padding(.bottom, 20)
                    
                    TextEditor(text: $addReviewVM.comment)
                        .scrollContentBackground(.hidden)
                        //.foregroundStyle(.black)
                        .background(Color(white: 0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 300)
                    
                    CustomButton(label: "Send") {
                        if addReviewVM.checkReview() {
                            addReviewVM.addReview()
                            dismiss()
                        } else {
                            addReviewVM.showAlert.toggle()
                        }
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Leave a Review")
                        .font(.customTitle3)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.customTitle3)
                    }
                }
                
            }
            .padding()
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    AddReviewView(addReviewVM: AddReviewVM(game: .test))
}
