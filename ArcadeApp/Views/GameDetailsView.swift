import SwiftUI

struct GameDetailsView: View {
    @Environment(GamesVM.self) private var gamesVM
    @State var detailsVM: GameDetailsVM
    @State private var option: PickerOptions = .review
    
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                gamesVM.selectedGame = nil
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 5)
            
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 5) {
                    GameCover(game: detailsVM.game, width: size.width / 2.5, height: size.height, namespace: namespace)
                    GameDetailsCard(detailsVM: detailsVM, namespace: namespace)
                            .frame(height: size.height)
                    }

                }
                .frame(height: 220)
            
            VStack(spacing: 10) {
                Picker(selection: $option) {
                    ForEach(PickerOptions.allCases) { option in
                        Text(option.rawValue)
                            .font(.body)
                    }
                } label: {
                    Text("Options")
                }
                .pickerStyle(.segmented)
                
                ReviewListView(detailsVM: detailsVM)

            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
            await detailsVM.loadGameDetails()
        }
        .toolbar(.hidden)
        .sheet(isPresented: $detailsVM.showAddReview) {
            AddReviewView(addReviewVM: AddReviewVM(game: detailsVM.game))
        }
    }
}

#Preview {
    GameDetailsView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test),
                    namespace: Namespace().wrappedValue)
    .environment(GamesVM(interactor: TestInteractor()))
}
