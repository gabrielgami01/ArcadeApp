import SwiftUI

struct MainView: View {
    @Environment(UserVM.self) private var userVM
    @Environment(GamesVM.self) private var gamesVM
    
    @Namespace private var myNamespace
    
    var body: some View {
        ZStack {
            HomeView()
                .namespace(myNamespace)
        }
    }
}

#Preview {
    MainView()
        .environment(UserVM())
        .environment(GamesVM(interactor: TestInteractor()))
}
