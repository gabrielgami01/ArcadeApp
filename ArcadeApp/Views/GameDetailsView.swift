import SwiftUI
import Charts

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(GameDetailsVM.self) private var detailsVM
    
    let game: Game?
    
    @State private var option: GameOptions = .about
    @State private var aboutAnimation = false
    @State private var scoresAnimation = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let game {
            VStack(alignment: .leading) {
                HStack(spacing: 15) {
                    CustomPicker(selected: $option, displayKeyPath: \.rawValue)
                    
                    Button {
                        withAnimation(.bouncy.speed(2)) {
                            option = .about
                        } completion: {
                            withAnimation {
                                gamesVM.selectedGame = nil
                            }
                        }
                    } label: {
                        Text("X")
                            .font(.customLargeTitle)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                
                ZStack {
                    if option == .about {
                        GameAboutView(game: game, animation: $aboutAnimation)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    if option == .score {
                        GameScoresView(game: game, animation: $scoresAnimation)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onChanged { value in
                            withAnimation(.bouncy) {
                                if value.startLocation.x > value.location.x {
                                    option = .score
                                } else if value.startLocation.x < value.location.x {
                                    option = .about
                                }
                            }
                        }
                )
            }
            .task {
                await detailsVM.getGameDetails(id: game.id)
            }
            .onDisappear {
                aboutAnimation = false
                scoresAnimation = false
                option = .about
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    GameDetailsView(game: .test)
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .background(Color.background)
        .namespace(Namespace().wrappedValue)
}


