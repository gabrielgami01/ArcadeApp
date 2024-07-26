import SwiftUI
import Charts

struct GameScoresView: View {
    @State var detailsVM: GameDetailsVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Group {
                    if detailsVM.scores.count <= 2 {
                        ContentUnavailableView("No scores", systemImage: "gamecontroller",
                                               description: Text("You need 2 or more scores to see the graphs."))
                    } else {
                        Chart {
                            ForEach(detailsVM.scores) { score in
                                if let scoreValue = score.score {
                                    LineMark(
                                        x: .value("Date", score.date),
                                        y: .value("Score", scoreValue)
                                    )
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { value in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.day())
                            }
                        }
//                        .chartYAxis {
//                            AxisMarks(values: .stride(by: 10)) { value in
//                                AxisGridLine()
//                                AxisTick()
//                                AxisValueLabel()
//                            }
//                        }
//                        .frame(height: 300)
//                        .padding()
                    }
                }
                .padding(.top, 15)
                .frame(height: 200)
                
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
                
                if !detailsVM.scores.isEmpty {
                    LazyVStack(alignment: .leading) {
                        ForEach(detailsVM.scores) { score in
                            ScoreCell(score: score)
                            Divider()
                        }
                    }
                } else {
                    ContentUnavailableView("No scores", systemImage: "gamecontroller",
                                           description: Text("You haven't any score for this game yet."))
                }
            }
        }
        .task {
            await detailsVM.loadGameDetails()
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


