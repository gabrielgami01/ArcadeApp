import SwiftUI

struct AddReviewView: View {
    @Environment(UserVM.self) private var userVM
    
    let game: Game
    @State private var addReviewVM = AddReviewVM()
    @State var detailsVM: GameDetailsVM
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focus: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CustomTextField(text: $addReviewVM.title, label: "Title", capitalization: .sentences)
                        .focused($focus)
                    
                    HStack(spacing: 20) {
                        Text("Rating")
                            .font(.customBody)
                        
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
                            .focused($focus)
                            .scrollContentBackground(.hidden)
                            .font(.customBody)
                            .background(.quinary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(height: 300)
                    }
                }
            }
            .onTapGesture {
                focus = false
            }
            .sheetToolbar(title: "Leave a review", confirmationLabel: "Send") {
                if let user = userVM.activeUser,
                   let review = addReviewVM.newReview(activeUser: user) {
                    if await detailsVM.addReviewAPI(review, to: game) {
                        detailsVM.addReview(review)
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .background(Color.background)
            .errorAlert(show: $detailsVM.showError)
        }
    }
}

#Preview {
    AddReviewView(game: .test ,detailsVM: GameDetailsVM(repository: TestRepository()))
        .environment(UserVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
