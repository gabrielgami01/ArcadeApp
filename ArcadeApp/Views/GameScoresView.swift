import SwiftUI
import Charts

struct GameScoresView: View {
    @State var detailsVM: GameDetailsVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                
                HStack {
                    Text("Your scores")
                        .font(.customTitle3)
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
                        .font(.customBody)
                    }
                }
                .padding(.vertical, 5)
                
                if !detailsVM.scores.isEmpty {
                    LazyVStack(alignment: .leading) {
                        ForEach(detailsVM.scores) { score in
                            ScoreCell(score: score)
                            Divider()
                        }
                    }
                } else {
                    CustomUnavailableView(title: "No scores", image: "gamecontroller", description: "You haven't any score for this game yet.")
                }
            }
        }
        .sheet(isPresented: $detailsVM.showAddScore) {
            AddScoreView(addScoreVM: AddScoreVM(game: detailsVM.game))
        }
        
    }
}

#Preview {
    GameScoresView(detailsVM: GameDetailsVM(interactor: TestInteractor(), game: .test))
        .padding()
}


