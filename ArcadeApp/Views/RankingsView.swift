import SwiftUI

struct RankingsView: View {
    @State var rankingsVM = RankingsVM()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(rankingsVM.games) { game in
                            Button {
                                withAnimation {
                                    rankingsVM.selectedGame = game
                                }
                            } label: {
                                GameRankingCell(game: game)
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
