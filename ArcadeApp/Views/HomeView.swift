import SwiftUI

enum HomePage: String, Identifiable, CaseIterable {
    case score = "Add score"
    case challenges = "Challenges"
    case rankings = "Rankings"
    case forum = "Forum"
    
    var id: Self { self }
}

struct HomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var showProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                .safeAreaPadding(.horizontal)
                ScrollView(.horizontal) {
                    LazyHStack {
                        HomePageCard(page: .score, image: "plus", color: .cyan)
                        HomePageCard(page: .challenges, image: "trophy", color: .green)
                        HomePageCard(page: .rankings, image: "rosette", color: .purple)
                        HomePageCard(page: .forum, image: "message", color: .orange)
                    }
                    .safeAreaPadding()
                    .scrollTargetLayout()
                }
                
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(gamesVM.featured) { game in
                            GameCard(game: game)
                        }
                    }
                }
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(gamesVM.favorites) { game in
                            GameCard(game: game)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}

struct HomePageCard: View {
    let page: HomePage
    let image: String
    let color: Color
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color.gradient.opacity(0.4))
                .frame(width: 100, height: 100)
                .overlay {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                }
            Text(page.rawValue)
                .font(.footnote)
                .bold()
        }
    }
}
