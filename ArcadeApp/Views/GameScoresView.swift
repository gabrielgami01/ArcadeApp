import SwiftUI

struct GameScoresView: View {
    @State var detailsVM: GameDetailsVM
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Your scores")
                    .font(.title3)
                    .bold()
                Spacer()
                Button {
                    detailsVM.showAddScore.toggle()
                } label: {
                    Label {
                        Text("Add new Score")
                    } icon: {
                        Image(systemName: "plus")
                    }
                    .font(.body)
                }
            }
            .padding(.vertical, 5)
        }
        .sheet(isPresented: $detailsVM.showAddScore) {
//            AddReviewView(addReviewVM: AddReviewVM(game: detailsVM.game))
        }
    }
}

#Preview {
    GameScoresView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
        .padding()
}
