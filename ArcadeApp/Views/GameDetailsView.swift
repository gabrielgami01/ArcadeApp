import SwiftUI
import Charts

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @State var detailsVM = GameDetailsVM()
    
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
                            withAnimation(.snappy) {
                                gamesVM.selectedGame = nil
                            }
                        }
                    }
                    
                    CustomPicker(activeSelection: $option) {$0.rawValue.capitalized}
                }
                .padding(.horizontal)
                
                ZStack {
                    if option == .about {
                        GameAboutView(detailsVM: detailsVM, game: game, animation: $aboutAnimation)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    if option == .score {
                        GameScoresView(detailsVM: detailsVM, game: game, animation: $scoresAnimation)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

#Preview {
    GameDetailsView(detailsVM: GameDetailsVM(interactor: TestInteractor()), game: .test)
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(UserVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
        .preferredColorScheme(.dark)
}


