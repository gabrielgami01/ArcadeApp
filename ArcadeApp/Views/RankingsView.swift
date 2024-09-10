import SwiftUI

struct RankingsView: View {
    @State var rankingsVM = RankingsVM()
    
    @Environment(\.namespace) private var namespace
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
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
                    HStack(alignment: .firstTextBaseline, spacing: 20) {
                        BackButton {
                            dismiss()
                        }
                        Text("Rankings")
                            .font(.customLargeTitle)
                    }
                    .stickyHeader()
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .opacity(rankingsVM.selectedGame == nil ? 1.0 : 0.0)
        .navigationBarBackButtonHidden()
        .padding(.horizontal)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .background(Color.background)
        .overlay {
            GameRankingView(rankingsVM: rankingsVM)
        }
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
