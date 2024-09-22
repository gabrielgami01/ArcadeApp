import SwiftUI

struct GameRankingView: View {
    @Environment(UserVM.self) private var userVM
    @State var rankingsVM = RankingsVM()
    
    let game: Game
    
    @State private var selectedUser: User?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                if !rankingsVM.rankingScores.isEmpty {
                    ForEach(rankingsVM.ranking, id: \.element.id) { index, rankingScore in
                        Button {
                            withAnimation {
                                if rankingScore.user != userVM.activeUser {
                                    selectedUser = rankingScore.user
                                }
                            }
                        } label: {
                            RankingScoreCell(index: index, rankingScore: rankingScore)
                        }
                        .buttonStyle(.plain)
                        
                    }
                } else {
                    CustomUnavailableView(title: "No scores", image: "gamecontroller",
                                          description: "There isn't any score for this game yet.")
                }
            }
            .disabled(selectedUser != nil)
            .blur(radius: selectedUser != nil ? 10 : 0)
        }
        .task {
            await rankingsVM.getGameRanking(id: game.id)
        }
        .onTapGesture {
            if selectedUser != nil {
                withAnimation {
                    selectedUser = nil
                }
            }
        }
        .padding(.horizontal)
        .overlay {
            if let selectedUser {
                UserCard(user: selectedUser)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    BackButton {
                        dismiss()
                    }
                    Text(game.name)
                        .font(.customLargeTitle)
                }
                .padding(.bottom, 5)
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        GameRankingView(rankingsVM: RankingsVM(interactor: TestInteractor()), game: .test)
            .environment(UserVM(interactor: TestInteractor()))
            .environment(SocialVM(interactor: TestInteractor()))
            .environment(ChallengesVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
    }
}

