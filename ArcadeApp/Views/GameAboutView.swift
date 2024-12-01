import SwiftUI

struct GameAboutView: View {
    @Environment(UserVM.self) private var userVM
    
    let game: Game
    @Binding var animation: Bool
    @State var detailsVM: GameDetailsVM
    
    @State private var showAddReview = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                GameAboutCard(game: game, animation: animation, detailsVM: detailsVM)
                
                VStack {
                    GameDetailsLabel(showAction: $showAddReview, title: "Player's Reviews") {
                        Label {
                            Text("Write a review")
                        } icon: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    
                    if !detailsVM.reviews.isEmpty {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(detailsVM.reviews) { review in
//                                Button {
//                                    if review.user.id != userVM.activeUser?.id {
//                                        withAnimation {
//                                            socialVM.selectedUser = review.user
//                                        }
//                                    }
//                                } label: {
//                                    ReviewCell(review: review)
//                                }
//                                .buttonStyle(.plain)
                                ReviewCell(review: review)
                            }
                        }
                    } else {
                        CustomUnavailableView(title: "No reviews", image: "gamecontroller",
                                              description: "There isn't any review for this game yet.")
                    }
                }
                .opacity(animation ? 1.0 : 0.0)
                .animation(.easeOut.delay(0.6), value: animation)
            }
            .padding(.horizontal)
        }
        .onAppear {
            animation = true
        }
        .sheet(isPresented: $showAddReview) {
            AddReviewView(game: game, detailsVM: detailsVM)
        }
    }
}

#Preview {
    GameAboutView(game: .test, animation: .constant(true), detailsVM: GameDetailsVM(repository: TestRepository()))
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
}



