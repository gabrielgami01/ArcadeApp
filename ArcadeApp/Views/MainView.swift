import SwiftUI

struct MainView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    var body: some View {
        ZStack {
            HomeView()
        }
    }
}

#Preview {
    MainView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}
