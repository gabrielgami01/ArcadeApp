import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    @Environment(GameSessionVM.self) private var gameSessionVM
    
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
                    
                    if let activeSession = gameSessionVM.activeSession {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("NOW PLAYING")
                                .font(.customTitle3)
                                .padding(.horizontal)
                            
                            HStack(alignment: .top, spacing: 10) {
                                GameCover(game: activeSession.game, width: 80, height: 120)
                                
                                VStack(spacing: 40){
                                    Text("Zelda: Ocarina of Time")
                                        .font(.customTitle)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .offset(y: 20)
                                    
                                    HStack {
                                        Text(gameSessionVM.sessionDuration.toDisplayString())
                                            .font(.customTitle2)
                                            .bold()
                                            .contentTransition(.numericText())
                                            .animation(.linear, value: gameSessionVM.sessionDuration)

                                        Spacer()

                                        TimerControl(image: "stop.fill", size: .regular, font: .customFootnote) {
                                            Task {
                                                if await gameSessionVM.endSessionAPI() {
                                                    gameSessionVM.endSession()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                        }
                        
                    }
                    
                    
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
        .environment(ChallengesVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .environment(GameSessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
