import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var selectedType: HomeScrollType = .featured
    @State private var activeNamespace: Namespace.ID?
    
    @Namespace private var namespaceSession
    @Namespace private var namespaceFeatured
    @Namespace private var namespaceFavorites
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if let user = userVM.activeUser {
                        Text("Hello \(user.username)")
                            .font(.customLargeTitle)
                            .padding(.horizontal)
                    }
                    
                    HStack {
                        NavigationLink(value: HomePage.challenges) {
                            PageButton(page: HomePage.challenges)
                        }
                        
                        Spacer()
                        
                        NavigationLink(value: HomePage.rankings) {
                            PageButton(page: HomePage.rankings)
                        }  
                    }
                    .buttonStyle(.plain)
                    .padding()
                    
                    ActiveSessionCard { game in
                        activeNamespace = namespaceSession
                        withAnimation {
                            gamesVM.selectedGame = game
                        }
                    }
                    .namespace(namespaceSession)
                    
                    GamesCarousel(games: gamesVM.featured, type: .featured) { game in
                        activeNamespace = namespaceFeatured
                        withAnimation {
                            gamesVM.selectedGame = game
                        }
                    }
                    .namespace(namespaceFeatured)
                    
                    GamesCarousel(games: gamesVM.favorites, type: .favorites) { game in
                        activeNamespace = namespaceFavorites
                        withAnimation {
                            gamesVM.selectedGame = game
                        }
                    }
                    .namespace(namespaceFavorites)
                }
            }
            .navigationDestination(for: HomePage.self) { page in
                switch page {
                    case .challenges:
                        ChallengesView()
                    case .rankings:
                        RankingsView()
                }
            }
            .navigationDestination(for: Game.self) { game in
                GameRankingView(game: game)
            }
            .tabBarInset()
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .background(Color.background)
            .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            .overlay {
                GameDetailsView(game: gamesVM.selectedGame)
                    .namespace(activeNamespace)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
