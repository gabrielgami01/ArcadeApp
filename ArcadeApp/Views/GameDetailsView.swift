import SwiftUI
import Charts

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(GameDetailsVM.self) private var detailsVM
    
    @State private var option: PickerOptions = .about
    
    @State private var aboutAnimation = false
    @State private var scoresAnimation = false
    
    @State private var displayedPoints = 0
    @State private var timer: Timer? = nil
    
    let game: Game?
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let game {
            VStack(alignment: .leading) {
                HStack {
                    BackButton {
                        withAnimation(.bouncy.speed(2)){
                            option = .about
                        } completion: {
                            withAnimation {
                                gamesVM.selectedGame = nil
                            }
                        }
                    }
                    
                    CustomPicker(activeSelection: $option) {$0.rawValue.capitalized}
                }
                
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
                        .onEnded { value in
                            withAnimation(.bouncy){
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
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    GameDetailsView(game: .test)
        .environment(UserVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(GameDetailsVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .background(Color.background)
        .namespace(Namespace().wrappedValue)
}


