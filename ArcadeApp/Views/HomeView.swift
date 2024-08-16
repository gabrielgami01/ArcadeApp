import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var selectedPage: HomePage?
    
    @Namespace private var namespaceFeatured
    @Namespace private var namespaceFavorites
    
    var body: some View {
        ZStack {
            home
                .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            if let game = gamesVM.selectedGame {
                GameDetailsView(detailsVM: GameDetailsVM(game: game))
                    .opacity(gamesVM.selectedGame == nil ? 0.0 : 1.0)
            }
        }
        .animation(.bouncy.speed(0.8), value: gamesVM.selectedGame)
        .namespace(gamesVM.selectedType == .featured ? namespaceFeatured : namespaceFavorites)
    }
    
    var home: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        if let user = userVM.activeUser {
                            Text("Hello \(user.username)")
                                .font(.customLargeTitle)
                        }
                        Spacer()
                        NavigationLink(value: HomePage.profile) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 15) {
                            PageButton(selectedPage: $selectedPage, page: .challenges, image: "trophy", color: .green)
                            PageButton(selectedPage: $selectedPage, page: .rankings, image: "rosette", color: .orange)
                            PageButton(selectedPage: $selectedPage, page: .forum, image: "message", color: .red)
                            PageButton(selectedPage: $selectedPage, page: .friends, image: "person.2", color: .purple)
                        }
                        .safeAreaPadding()
                    }
                    
                    GamesCarousel(type: .featured)
                        .namespace(namespaceFeatured)
                    GamesCarousel(type: .favorites)
                        .namespace(namespaceFavorites)

                }
            }
            .navigationDestination(for: HomePage.self) { page in
                switch page {
                    case .challenges:
                        ChallengesView()
                    case .rankings:
                        RankingsView()
                    case .forum, .friends:
                        EmptyView() // Rutas para otras vistas
                    case .profile:
                        ProfileView()
                }
            }
            .navigationDestination(for: Game.self) { game in
                GameRankingView(rankingVM: RankingsVM(game: game))
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .background(Color.backgroundColor)
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}
