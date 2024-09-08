import SwiftUI

struct GameAboutView: View {
    @Environment(UserVM.self) private var userVM
    @State var detailsVM: GameDetailsVM
    let game: Game
    @Binding var animation: Bool
    
    @State private var selectedUser: User?
    @State private var showAddReview = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    GameCover(game: game, width: 150, height: 220)
                    
                    GameAboutCard(detailsVM: detailsVM, game: game, animation: animation)
                }
                
                Group {
                    HStack {
                        Text("Player Reviews")
                            .font(.customTitle3)
                            .bold()
                        Spacer()
                        Button {
                            showAddReview.toggle()
                        } label: {
                            Label {
                                Text("Write a Review")
                            } icon: {
                                Image(systemName: "square.and.pencil")
                            }
                            .font(.customBody)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    if !detailsVM.reviews.isEmpty {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(detailsVM.reviews) { review in
                                Button {
                                    withAnimation {
                                        if review.user.id != userVM.activeUser?.id {
                                            selectedUser = review.user
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
            .disabled(selectedUser != nil)
        }
        .onAppear {
            animation = true
        }
        .sheet(isPresented: $showAddReview) {
            AddReviewView(addReviewVM: AddReviewVM(game: game))
        }
        .blur(radius: selectedUser != nil ? 10 : 0)
        .onTapGesture {
            if selectedUser != nil {
                withAnimation {
                    selectedUser = nil
                }
            }
        }
        .overlay {
            if let selectedUser {
                UserCard(user: selectedUser)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    GameAboutView(detailsVM: GameDetailsVM(interactor: TestInteractor()), game: .test, animation: .constant(true))
        .environment(UserVM(interactor: TestInteractor()))
        .background(Color.background)
        .preferredColorScheme(.dark)
}

