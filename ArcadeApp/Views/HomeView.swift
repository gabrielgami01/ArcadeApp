import SwiftUI

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var showProfile = false
    //@State private var textAnimation = false
    
    @Namespace private var myNamespace
    @Namespace private var another
    
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
        .namespace(myNamespace)
    }
    
    var home: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Hello user")
                        .font(.customLargeTitle)
                    //AsyncText(label: "Hello User", font: .customLargeTitle)
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
                    LazyHStack(spacing: 10) {
                        PageButton(state: .constant(false), page: .challenges, image: "trophy", color: .green)
                        PageButton(state: .constant(false), page: .rankings, image: "rosette", color: .orange)
                        PageButton(state: .constant(false), page: .forum, image: "message", color: .red)
                        PageButton(state: .constant(false), page: .friends, image: "person.2", color: .purple)
                    }
                    .safeAreaPadding()
                }
                
                GamesCarousel(type: .featured)
                GamesCarousel(type: .favorites)

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
