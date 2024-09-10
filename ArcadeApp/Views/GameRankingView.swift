import SwiftUI

struct GameRankingView: View {
    @Environment(UserVM.self) private var userVM
    @State var rankingsVM: RankingsVM
    @State var animation: Bool = false
    @State private var selectedUser: User?
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let game = rankingsVM.selectedGame {
            ScrollView {
                LazyVStack(spacing: 15) {
                    Section {
                        Group {
                            if !rankingsVM.rankingScores.isEmpty {
                                ForEach(rankingsVM.ranking, id: \.element.id) { index, rankingScore in
                                    Button {
                                        withAnimation {
                                            if rankingScore.user.id != userVM.activeUser?.id {
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
                        .opacity(animation ? 1.0 : 0.0)
                    } header: {
                        HStack(alignment: .firstTextBaseline, spacing: 20) {
                            BackButton {
                                withAnimation {
                                    rankingsVM.selectedGame = nil
                                }
                            }
                            
                            if let namespace {
                                Text(game.name)
                                    .font(.customLargeTitle)
                                    .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                            }
                        }
                        .stickyHeader()
                    }
                }
                .disabled(selectedUser != nil)
            }
            .onAppear {
                rankingsVM.getGameRanking(id: game.id)
                withAnimation(.easeOut.delay(0.4)) {
                    animation = true
                }
            }
            .onDisappear {
                animation = false
            }
            .ignoresSafeArea(edges: .top)
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
            .background(Color.background)
        }
    }
}

#Preview {
    GameRankingView(rankingsVM: RankingsVM(interactor: TestInteractor(), selectedGame: .test))
        .environment(UserVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}

