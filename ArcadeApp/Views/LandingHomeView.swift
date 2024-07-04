import SwiftUI

enum HomePage: String, Identifiable, CaseIterable {
    case score = "Add score"
    case challenges = "Challenges"
    case rankings = "Rankings"
    case forum = "Forum"
    
    var id: Self { self }
}

struct LandingHomeView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var showProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
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
                    
                    Text("FEATURED")
                        .font(.headline)
                        .safeAreaPadding(.horizontal)
                    HomeScrollView(games: gamesVM.featured)
                    
                    Text("FAVORITES")
                        .font(.headline)
                        .safeAreaPadding(.horizontal)
                    HomeScrollView(games: gamesVM.favorites)
                }
            }
            .scrollIndicators(.hidden)
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
            .background(Color("backgroundColor"))
        }
        
    }
}

#Preview {
    LandingHomeView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}

