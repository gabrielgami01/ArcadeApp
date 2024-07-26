import SwiftUI

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @State var detailsVM: GameDetailsVM
    @State private var option: PickerOptions = .about
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button {
                    gamesVM.selectedGame = nil
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                
                Picker(selection: $option) {
                    ForEach(PickerOptions.allCases) { option in
                        Text(option.rawValue)
                            .font(.body)
                    }
                } label: {
                    Text("Options")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
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
        .toolbar(.hidden)
        .animation(.easeInOut, value: option)
    }
}

#Preview {
    GameDetailsView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
        .environment(GamesVM(interactor: TestInteractor()))
}
