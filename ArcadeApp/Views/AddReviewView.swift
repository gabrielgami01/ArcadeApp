import SwiftUI

struct AddReviewView: View {
    @State var addReviewVM: AddReviewVM
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CustomTextField(value: $addReviewVM.title, isError: $addReviewVM.showAlert, label: "Title")
                    HStack(spacing: 40) {
                        Text("Rating")
                            .font(.body)
                            .bold()
                        RatingComponent(rating: $addReviewVM.rating, mode: .rate)
                    }

    //                    TextViewUIKit(text: $comment, maxLines: 4)
    //                        .frame(height: 100)
    //                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    TextEditor(text: $addReviewVM.comment)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.black)
                        .background(.white)
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
            .showAlert(show: $addReviewVM.showAlert, text: addReviewVM.errorMsg)
            .safeAreaPadding()
            .background(Color("backgroundColor"))
        .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    AddReviewView(addReviewVM: AddReviewVM(game: .test))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
