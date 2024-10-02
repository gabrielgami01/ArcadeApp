import SwiftUI

struct MainTabView: View {
    @Environment(GamesVM.self) private var gamesVM
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = .clear
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        let itemAppearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "VT323", size: 15)!]
        itemAppearance.setTitleTextAttributes(attributes, for: .normal)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            GameListView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ProfileView()
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
