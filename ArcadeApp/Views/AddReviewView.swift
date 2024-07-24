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
                            .font(.body)
                            .bold()
                        RatingComponent(rating: $addReviewVM.rating, mode: .rate)
                    }
                    .padding(.bottom, 20)
                    
                    TextEditor(text: $addReviewVM.comment)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.black)
                        .background(Color(white: 0.90))
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
            .navigationTitle("Leave a Review")
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
    AddReviewView(addReviewVM: AddReviewVM(game: .test))
}
