import SwiftUI
import Charts

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @State private var detailsVM = GameDetailsVM()
    
    let game: Game?
    
    @State private var option: GameOptions = .about
    @State private var aboutAnimation = false
    @State private var scoresAnimation = false
    @State private var sessionAnimation = false
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let game {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    BackButton {
                        withAnimation(.bouncy.speed(2)) {
                            option = .about
                        } completion: {
                            withAnimation {
                                gamesVM.selectedGame = nil
                            }
                        }
                    }
                    
                    PillPicker(selected: $option)
                }
                .padding(.horizontal)
                
                ZStack {
                    GameAboutView(game: game, animation: $aboutAnimation, detailsVM: detailsVM)
                        .offset(x: option == .about ? 0 : option == .score ? -UIDevice.width : option == .session ? -UIDevice.width * 2 : 0)
                        .opacity(option != .about ? 0.0 : 1.0)
                    
                    GameScoresView(game: game, animation: scoresAnimation, detailsVM: detailsVM)
                        .offset(x: option == .about ? UIDevice.width : option == .score ? 0 : option == .session ? -UIDevice.width : 0)
                    
                    GameSessionView(game: game, animation: sessionAnimation, detailsVM: detailsVM)
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
            .refreshable {
                Task {
                    await detailsVM.getGameDetails(id: game.id)
                }
            }
            .onDisappear {
                aboutAnimation = false
                scoresAnimation = false
                sessionAnimation = false
                option = .about
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollBounceBehavior(.basedOnSize)
            .background(Color.background)
            .errorAlert(show: $detailsVM.showError)
        }
    }
}

#Preview {
    GameDetailsView(game: .test)
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .environment(SocialVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .namespace(Namespace().wrappedValue)
}


