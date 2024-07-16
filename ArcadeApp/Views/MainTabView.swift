import SwiftUI

struct MainTabView: View {
    @Environment(UserVM.self) private var loginVM
    @Environment(GamesVM.self) private var gamesVM
    var body: some View {
        TabView {
           MainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
//        .onAppear {
//            let appearance = UITabBarAppearance()
//            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//            appearance.backgroundColor = .clear
//            UITabBar.appearance().standardAppearance = appearance
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//        }
    }
}

#Preview {
    MainTabView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}
