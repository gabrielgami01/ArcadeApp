import SwiftUI

enum HomePage: String, Identifiable, CaseIterable {
    case friends = "Friends"
    case challenges = "Challenges"
    case rankings = "Rankings"
    case forum = "Forum"
    
    var id: Self { self }
}

enum HomeScrollType: String, Identifiable, CaseIterable {
    case featured
    case favorites
    
    var id: Self { self }
}

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @Namespace private var namespaceFeatured
    @Namespace private var namespaceFavorites
    
    @State private var showProfile = false
    
    var body: some View {
        ZStack {
            home
                .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
            if let game = gamesVM.selectedGame {
                GameDetailsView(namespace: gamesVM.homeType == .favorites ? namespaceFavorites : namespaceFeatured,
                                detailsVM: GameDetailsVM(game: game))
                    .opacity(gamesVM.selectedGame == nil ? 0.0 : 1.0)
            }
        }
        .animation(.bouncy.speed(0.6), value: gamesVM.selectedGame)
    }
    
    var home: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Hello user")
                        .font(.largeTitle)
                    Spacer()
                    Button {
                        showProfile.toggle()
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                ScrollView(.horizontal) {
                    LazyHStack {
                        HomePageButton(state: .constant(false), page: .challenges, image: "trophy", color: .cyan)
                        HomePageButton(state: .constant(false), page: .rankings, image: "rosette", color: .green)
                        HomePageButton(state: .constant(false), page: .forum, image: "message", color: .purple)
                        HomePageButton(state: .constant(false), page: .friends, image: "person.2", color: .orange)
                    }
                    .safeAreaPadding()
                }
                
                HomeGamesScroll(games: gamesVM.featured, type: .featured, namespace: namespaceFeatured)
                HomeGamesScroll(games: gamesVM.favorites, type: .favorites, namespace: namespaceFavorites)
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .fullScreenCover(isPresented: $showProfile) {
            ProfileView()
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}

struct GameCard: View {
    let game: Game
    let namespace: Namespace.ID
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: -25) {
                GameInfoCard(game: game, namespace: namespace)
                    .frame(width: size.width / 2, height: size.height * 0.8)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(white: 0.95))
                            .shadow(color: .primary.opacity(0.08), radius: 8, x: 5, y: 5)
                            .shadow(color: .primary.opacity(0.08), radius: 8, x: -5, y: -5)
                    }
                    .zIndex(1)
                
                ZStack {
                    GameCover(game: game, namespace: namespace, width: size.width / 2, height: size.height)
                        
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
        }
        .frame(width: UIDevice.width - 16, height: 220)
    }
}

struct HomePageButton: View {
    @Binding var state: Bool
    let page: HomePage
    let image: String
    let color: Color
    
    var body: some View {
        VStack {
            Button {
                state.toggle()
            } label: {
                Image(systemName: image)
                    .font(.largeTitle)
                    .padding(20)
                    .frame(width: 80)
            }
            .tint(color.gradient.opacity(0.7))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 20))
            Text(page.rawValue)
                .font(.footnote)
                .bold()
        }
    }
}

struct HomeGamesScroll: View {
    let games: [Game]
    let type: HomeScrollType
    let namespace: Namespace.ID
    
    @Environment(GamesVM.self) private var gamesVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type.rawValue.uppercased())
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(games) { game in
                        //Text(gamesVM.games.count.formatted())
                        Button {
                            gamesVM.homeType = type
                            gamesVM.selectedGame = game
                        } label: {
                            GameCard(game: game, namespace: namespace)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            gamesVM.isLastItem(game: game)
                        }
                    }
                }
                .padding(.horizontal)
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
