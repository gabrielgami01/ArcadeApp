import SwiftUI

struct SearchCell: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(\.modelContext) private var context
    @State var searchVM: SearchVM

    let game: Game
    var isRecent: Bool = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.snappy){
                        gamesVM.selectedGame = game
                    }
                    if !isRecent {
                        try? searchVM.saveGameSearch(game: game, context: context)
                    }
                } label: {
                    HStack(spacing: 10) {
                        GameCover(game: game, width: 60, height: 60)
                        if let namespace{
                            Text(game.name)
                                .font(.customBody)
                                .matchedGeometryEffect(id: "\(game.id)_NAME", in: namespace, properties: .position)
                        }
                    }
                }
                
                Spacer()
                
                if isRecent {
                    Button {
                        try? searchVM.deleteGameSearch(game: game, context: context)
                    } label: {
                        Text("X")
                            .font(.customTitle)
                    }
                }
            }
            .buttonStyle(.plain)
    
            Divider()
        }
    }
}

#Preview {
    SearchCell(searchVM: SearchVM(interactor: TestInteractor()), game: .test)
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(SearchVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}
