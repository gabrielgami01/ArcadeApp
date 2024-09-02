import SwiftUI

struct MainTabView: View {
    @Environment(UserVM.self) private var loginVM
    @Environment(GamesVM.self) private var gamesVM
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .onAppear {
                    gamesVM.selectedGame = nil
                }

            GameListView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .onAppear {
                    gamesVM.selectedGame = nil
                }
        }
        .onAppear {
            let itemAppearance = UITabBarItem.appearance()
            let attributes = [NSAttributedString.Key.font: UIFont(name: "VT323", size: 15)!]
            itemAppearance.setTitleTextAttributes(attributes, for: .normal)
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = .clear
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
        .environment(UserVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
}
