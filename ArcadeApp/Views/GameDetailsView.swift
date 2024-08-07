import SwiftUI

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @State var detailsVM: GameDetailsVM
    @State private var option: PickerOptions = .about
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                BackButton {
                    gamesVM.selectedGame = nil
                }
                
                CustomPicker(selectedOption: $option)
                
            }
            .padding(.bottom, 5)
            
            ZStack {
                GameAboutView(detailsVM: detailsVM)
                    .offset(x: option == .about ? 0 : -UIDevice.width)
                    .opacity(option == .about ? 1.0 : 0.0)
                GameScoresView(detailsVM: detailsVM)
                    .offset(x: option == .about ? UIDevice.width : 0)
                    .opacity(option == .about ? 0.0 : 1.0)
            }
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        if value.startLocation.x > value.location.x {
                            option = .score
                        } else if value.startLocation.x < value.location.x {
                            option = .about
                        }
                    }
            )
        }
        .task {
            await detailsVM.loadGameDetails()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.easeInOut, value: option)
        .background(Color.background)
    }
}

#Preview {
    GameDetailsView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
        .environment(GamesVM(interactor: TestInteractor()))
        .namespace(Namespace().wrappedValue)
}


