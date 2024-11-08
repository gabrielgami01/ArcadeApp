import SwiftUI

struct GameAboutView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GameDetailsVM.self) private var detailsVM
    @Environment(SocialVM.self) private var socialVM
    
    let game: Game
    @Binding var animation: Bool
    
    @State private var selectedUser: User?
    @State private var showAddReview = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    GameCover(game: game, width: 150, height: 220)
                    
                    GameAboutCard(game: game, animation: animation)
                }
                
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
                                Button {
                                    if review.user.id != userVM.activeUser?.id {
                                        withAnimation {
                                            socialVM.selectedUser = review.user
                                        }
                                    }
                                } label: {
                                    ReviewCell(review: review)
                                }
                                .buttonStyle(.plain)
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
            AddReviewView(game: game)
        }
    }
}

#Preview {
    GameAboutView(game: .test, animation: .constant(true))
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
}



