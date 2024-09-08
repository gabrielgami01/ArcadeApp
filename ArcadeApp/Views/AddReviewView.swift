import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State var addReviewVM: AddReviewVM
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                CustomTextField(text: $addReviewVM.title, label: "Title")
                
                HStack(spacing: 40) {
                    Text("Rating")
                        .font(.customBody)
                        .bold()
                    RatingComponent(rating: $addReviewVM.rating, mode: .rate)
                }
                .padding(.bottom, 20)
                
                ZStack(alignment: .topLeading) {
                    if addReviewVM.comment.isEmpty {
                        Text("Add your comment")
                            .font(.customBody)
                            .padding(5)
                            
                    }
                    
                    TextEditor(text: $addReviewVM.comment)
                        .scrollContentBackground(.hidden)
                        .font(.customBody)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 300)
                }
                
                Spacer()
            }
            .sheetToolbar(title: "Leave a Review", confirmationLabel: "Send") {
                if addReviewVM.checkReview() {
                    addReviewVM.addReview()
                    dismiss()
                } else {
                    addReviewVM.showError.toggle()
                }
            }
            .showAlert(show: $addReviewVM.showError, text: addReviewVM.errorMsg)
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .background(Color.background)
        }
    }
}

#Preview {
    AddReviewView(addReviewVM: AddReviewVM(game: .test, interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
