import SwiftUI
import Charts

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(GameDetailsVM.self) private var detailsVM
    
    let game: Game?
    
    @State private var option: GameOptions = .about
    @State private var aboutAnimation = false
    @State private var scoresAnimation = false
    @State private var sessionAnimation = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let game {
            VStack(alignment: .leading) {
                HStack(spacing: 15) {
                    PillPicker(selected: $option)
                    
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
                    GameAboutView(game: game, animation: $aboutAnimation)
                        .offset(x: option == .about ? 0 : option == .score ? -UIDevice.width : option == .session ? -UIDevice.width * 2 : 0)
                        .opacity(option != .about ? 0.0 : 1.0)
                    
                    GameScoresView(game: game, animation: $scoresAnimation)
                        .offset(x: option == .about ? UIDevice.width : option == .score ? 0 : option == .session ? -UIDevice.width : 0)
                    
                    GameSessionView(game: game, animation: $sessionAnimation)
                        .offset(x: option == .about ? UIDevice.width * 2 : option == .score ? UIDevice.width : option == .session ? 0 : 0)
                        .opacity(option != .session ? 0.0 : 1.0)
                }
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { value in
                            withAnimation(.bouncy) {
                                if value.startLocation.x > value.location.x {
                                    switch option {
                                        case .about:
                                            option = .score
                                        case .score:
                                            option = .session
                                        case .session:()
                                    }
                                } else if value.startLocation.x < value.location.x {
                                    switch option {
                                        case .about:
                                            withAnimation {
                                                gamesVM.selectedGame = nil
                                            }
                                        case .score:
                                            option = .about
                                        case .session:
                                            option = .score
                                    }
                                }
                            }
                        }
                )
            }
            .onChange(of: option) { oldValue, newValue in
                switch newValue {
                    case .about:()
                    case .score:
                        scoresAnimation = true
                    case .session:
                        sessionAnimation = true
                }
            }
            .task {
                await detailsVM.getGameDetails(id: game.id)
            }
            .onDisappear {
                aboutAnimation = false
                scoresAnimation = false
                sessionAnimation = false
                option = .about
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar(.hidden, for: .tabBar)
            .background(Color.background)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    GameDetailsView(game: .test)
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}


