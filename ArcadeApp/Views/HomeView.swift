import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var selectedType: HomeScrollType = .featured
    
    @Namespace private var namespaceFeatured
    @Namespace private var namespaceFavorites
    
    var body: some View {
        @Bindable var gamesBVM = gamesVM
        
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
                        
                        Spacer()
                        
                        NavigationLink(value: HomePage.social) {
                            PageButton(page: HomePage.social)
                        }
                        
                    }
                    .buttonStyle(.plain)
                    .padding()
                    
                    ActiveSessionCard()
                    
                    GamesCarousel(selectedType: $selectedType, type: .featured, games: gamesVM.featured)
                        .namespace(namespaceFeatured)
                    
                    GamesCarousel(selectedType: $selectedType, type: .favorites, games: gamesVM.favorites)
                        .namespace(namespaceFavorites)
                }
                .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            }
            .navigationDestination(for: HomePage.self) { page in
                Group {
                    switch page {
                        case .challenges:
                            ChallengesView()
                        case .rankings:
                            RankingsView()
                        case .social:
                            SocialView()
                    }
                }
                .namespace(namespaceFeatured)
            }
            .navigationDestination(for: Game.self) { game in
                GameRankingView(game: game)
            }
            .overlay {
                GameDetailsView(game: gamesVM.selectedGame)
            }
            .showAlert(show: $gamesBVM.showError, text: gamesVM.errorMsg)
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
            .background(Color.background)
            .namespace(selectedType == .featured ? namespaceFeatured : namespaceFavorites)
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
