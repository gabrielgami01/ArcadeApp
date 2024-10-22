import SwiftUI
import Charts

struct GameScoresView: View {
    @Environment(GameDetailsVM.self) private var detailsVM
    
    let game: Game
    @Binding var animation: Bool
    
    @State private var showAddScore = false
    
    @State private var selectedScore: Score?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    if detailsVM.verifiedScores.count > 1 {
                        Chart {
                            ForEach(detailsVM.verifiedScores) { score in
                                if let points = score.score {
                                    LineMark(
                                        x: .value("Date", score.date),
                                        y: .value("Score", points)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    
                                    PointMark(
                                        x: .value("Date", score.date),
                                        y: .value("Score", points)
                                    )
                                    .symbolSize(80)
                                    
                                    if let selectedScore, let value = selectedScore.score {
                                        RuleMark(
                                            x: .value("Date", selectedScore.date),
                                            yStart: .value("Score Start", 0),
                                            yEnd: .value("Score", value)
                                        )
                                        .lineStyle(.init(lineWidth: 2, dash: [5]))
                                        .foregroundStyle(Color.blue)
                                        .annotation(position: .top) {
                                            Text("Score: \(value)")
                                                .font(.customCallout)
                                                .padding(8)
                                                .background(Color.black.opacity(0.8))
                                                .cornerRadius(10)
                                        }
                                    }
                                                    
                               }
                            }
                        }
                        .chartYScale(domain: 0...detailsVM.maxDisplayScore)
                        .chartXScale(domain: detailsVM.minDisplayDate...detailsVM.maxDisplayDate)
                        .chartOverlay { proxy in
                            GeometryReader { geo in
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                let location = value.location
                                                if let date: Date = proxy.value(atX: location.x),
                                                   let closestScore = detailsVM.verifiedScores.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) }) {
                                                    selectedScore = closestScore
                                                }
                                            }
                                            .onEnded { _ in
                                                selectedScore = nil
                                            }
                                    )
                            }
                        }
                        .padding()
                        .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
                    } else {
                      CustomUnavailableView(title: "Chart unavailable", image: "chart.xyaxis.line",
                                              description: "You need 2 or more scores to see the chart.")
                    }
                }
                .opacity(animation ? 1.0: 0.0)
                .animation(.easeInOut, value: animation)
                .frame(height: 220)
                
                VStack {
                    GameDetailsLabel(showAction: $showAddScore, title: "Your scores") {
                        Label {
                            Text("Add new score")
                        } icon: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    if !detailsVM.scores.isEmpty {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(detailsVM.scores) { score in
                                ScoreCell(score: score)
                            }
                        }
                    } else {
                        CustomUnavailableView(title: "No scores", image: "gamecontroller",
                                              description: "You haven't any score for this game yet.")
                    }
                }
                .opacity(animation ? 1.0: 0.0)
                .animation(.easeInOut.delay(0.4), value: animation)
            }
            .padding(.horizontal)
        }
        .onAppear {
            print("scores")
        }
        .sheet(isPresented: $showAddScore) {
           AddScoreView(game: game)
        }
    }
}

#Preview {
    GameScoresView(game: .test, animation: .constant(true))
        .environment(UserVM(repository: TestRepository()))
        .environment(GamesVM(repository: TestRepository()))
        .environment(GameDetailsVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .background(Color.background)
}
