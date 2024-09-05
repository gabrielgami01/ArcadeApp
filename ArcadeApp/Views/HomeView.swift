import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var selectedPage: HomePage?
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
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 25) {
                            PageButton(selectedPage: $selectedPage, page: .challenges)
                            PageButton(selectedPage: $selectedPage, page: .rankings)
                            PageButton(selectedPage: $selectedPage, page: .social)
                        }
                        .safeAreaPadding()
                    }
                    
                    GamesCarousel(selectedType: $selectedType, type: .featured, games: gamesVM.featured)
                    .namespace(namespaceFeatured)
                    
                    GamesCarousel(selectedType: $selectedType, type: .favorites, games: gamesVM.favorites)
                    .namespace(namespaceFavorites)
                }
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
            .showAlert(show: $gamesBVM.showError, text: gamesVM.errorMsg)
            .overlay {
                GameDetailsView(game: gamesVM.selectedGame)
            }
            .namespace(selectedType == .featured ? namespaceFeatured : namespaceFavorites)
            .background(Color.background)
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
