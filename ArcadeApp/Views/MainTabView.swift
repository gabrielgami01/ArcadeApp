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
                .onAppear {
                    gamesVM.selectedGame = nil
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .onAppear {
                    gamesVM.selectedGame = nil
                }
        }
        .onAppear {
            let appearance = UITabBarItem.appearance()
            let attributes = [NSAttributedString.Key.font: UIFont(name: "VT323", size: 15)!]
            appearance.setTitleTextAttributes(attributes, for: .normal)
        }
    }
}

#Preview {
    MainTabView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}
