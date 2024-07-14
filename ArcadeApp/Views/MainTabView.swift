import SwiftUI

struct MainTabView: View {
    @Environment(UserVM.self) private var loginVM
    
    var body: some View {
        TabView {
//           HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            Button {
                loginVM.logout()
            } label: {
                Text("Logout")
            }
            .tabItem {
                Label("Logout", systemImage: "xmark")
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
