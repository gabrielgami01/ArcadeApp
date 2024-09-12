import SwiftUI

struct MainTabView: View {
    @Environment(UserVM.self) private var loginVM
    @Environment(GamesVM.self) private var gamesVM
    
    init() {
        let itemAppearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "VT323", size: 15)!]
        itemAppearance.setTitleTextAttributes(attributes, for: .normal)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .onAppear {
                    gamesVM.selectedGame = nil
                }

            GameListView()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .onAppear {
                    gamesVM.selectedGame = nil
                }
            
            ProfileView()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .onAppear {
                    gamesVM.selectedGame = nil
                }
        }
       
    }
}

#Preview {
    MainTabView()
        .environment(UserVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(GameDetailsVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
