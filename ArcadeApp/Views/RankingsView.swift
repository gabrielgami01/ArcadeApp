import SwiftUI

struct RankingsView: View {
    @State var rankingsVM = RankingsVM()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(rankingsVM.games) { game in
                            Button {
                                withAnimation(.snappy) {
                                    rankingsVM.selectedGame = game
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    GameCover(game: game, width: 60, height: 60)
                                        
                                    if let namespace {
                                        Text(game.name)
                                            .font(.customBody)
                                            .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                                    }
                                    
                                    Spacer()
                                }
                                .onAppear {
                                    rankingsVM.isLastGame(game)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        CustomHeader(title: "Rankings")
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .padding(.horizontal)
        .overlay {
            GameRankingView(rankingsVM: rankingsVM)
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NavigationStack {
        RankingsView(rankingsVM: RankingsVM(interactor: TestInteractor()))
            .environment(UserVM(interactor: TestInteractor()))
            .preferredColorScheme(.dark)
            .namespace(Namespace().wrappedValue)
    }
}
