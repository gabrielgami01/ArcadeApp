import SwiftUI

struct MainTabView: View {
    @Environment(SocialVM.self) private var socialVM
    
    @AppStorage("firstTime") private var firstTime: Bool = true
    
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
        @Bindable var socialBVM = socialVM
        
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
        .sheet(isPresented: $firstTime) {
            OnboardingView()
                .interactiveDismissDisabled(true)
        }
        .userPopup(selectedUser: $socialBVM.selectedUser)
    }
}

#Preview {
    MainTabView()
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .environment(BadgesVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
