import SwiftUI

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
                GameDetailsView(detailsVM: GameDetailsVM(game: game),
                                namespace: gamesVM.homeType == .favorites ? namespaceFavorites : namespaceFeatured)
                    .opacity(gamesVM.selectedGame == nil ? 0.0 : 1.0)
            }
        }
        .animation(.bouncy.speed(0.8), value: gamesVM.selectedGame)
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
                        PageButton(state: .constant(false), page: .challenges, image: "trophy", color: .cyan)
                        PageButton(state: .constant(false), page: .rankings, image: "rosette", color: .green)
                        PageButton(state: .constant(false), page: .forum, image: "message", color: .purple)
                        PageButton(state: .constant(false), page: .friends, image: "person.2", color: .orange)
                    }
                    .safeAreaPadding()
                }
                
                GamesScroll(type: .featured, namespace: namespaceFeatured)
                GamesScroll(type: .favorites, namespace: namespaceFavorites)
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
