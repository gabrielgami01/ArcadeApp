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
                    
                    HStack(spacing: 25) {
                        ForEach(HomePage.allCases) { page in
                            NavigationLink(value: page) {
                                PageButton(page: page)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    
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
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(UserVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
