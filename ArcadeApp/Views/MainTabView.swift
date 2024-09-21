import SwiftUI

struct MainTabView: View {
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
            GameListView()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ProfileView()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
       
    }
}

#Preview {
    MainTabView()
        .environment(UserVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(GameDetailsVM(interactor: TestInteractor()))
        .environment(ChallengesVM(interactor: TestInteractor()))
        .environment(SocialVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
