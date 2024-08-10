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
                        .font(.customBody)
                        .background(.quinary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 300)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheetToolbar(title: "Leave a Review", confirmationLabel: "Send") {
                if addReviewVM.checkReview() {
                    addReviewVM.addReview()
                    dismiss()
                } else {
                    addReviewVM.showAlert.toggle()
                }
            }
            .padding()
            .scrollBounceBehavior(.basedOnSize)
            .background(Color.background)
        }
    }
}

#Preview {
    AddReviewView(addReviewVM: AddReviewVM(game: .test))
}
