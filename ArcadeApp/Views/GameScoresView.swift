import SwiftUI
import Charts

struct GameScoresView: View {
    @State var detailsVM: GameDetailsVM
    @State private var showSelectionBar = false
    @State private var offsetX = 0.0
    @State private var offsetY = 0.0
    @State private var selectedDay: Date = .distantPast
    @State private var selectedScore: Int? = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Group {
                    if detailsVM.verifiedScores.count > 1 {
                        Chart {
                            ForEach(detailsVM.verifiedScores) { score in
                                if let value = score.score {
                                    LineMark(
                                        x: .value("Date", score.date),
                                        y: .value("Score", value)
                                    )
                                    .lineStyle(StrokeStyle(lineWidth: 2, lineJoin: .round))
                                    PointMark(
                                        x: .value("Date", score.date),
                                        y: .value("Score", value)
                                    )
                                }
                            }
                        }
                        .chartXAxis {}
                        .chartYAxis {
                            AxisMarks(preset: .aligned, values: .automatic(desiredCount: 5))
                        }
                    } else {
                        CustomUnavailableView(title: "Chart unavailable", image: "chart.xyaxis.line", description: "You need 2 or more scores to see the chart")
                    }
                }
                .padding()
                .frame(height: 220)
                
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


