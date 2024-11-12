import SwiftUI

struct MainTabView: View {
    @AppStorage("firstTime") private var firstTime: Bool = true
    @Environment(GamesVM.self) private var gamesVM
    
    @State private var activeTab: Tabs = .home
    @State private var tabbarHeight: CGFloat = 0.0
    
    private let tabs: [TabItem] = [
        TabItem(name: "Home", symbol: "house", tab: .home),
        TabItem(name: "Search", symbol: "magnifyingglass", tab: .search),
        TabItem(name: "Profile", symbol: "person", tab: .profile)
    ]
    
    var body: some View {
        ZStack {
            HomeView()
                .opacity(activeTab == .home ? 1.0 : 0.0)
                
            GameListView()
                .opacity(activeTab == .search ? 1.0 : 0.0)
            
            ProfileView()
                .opacity(activeTab == .profile ? 1.0 : 0.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                ForEach(tabs) { item in
                    Button {
                        activeTab = item.tab
                    } label: {
                        VStack {
                            Image(systemName: item.symbol)
                                .font(.customHeadline)
                    
                            Text(item.name)
                                .font(.customSubheadline)
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(activeTab == item.tab ? .accent : .secondary)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.size.height, initial: true) {
                            tabbarHeight = proxy.size.height
                        }
                }
            }
            .padding()
            .opacity(gamesVM.selectedGame == nil ? 1.0 : 0.0)
        }
        .ignoresSafeArea(edges: .bottom)
        .tabBarHeight(tabbarHeight)
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
