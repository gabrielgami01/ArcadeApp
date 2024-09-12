import SwiftUI
import Charts

struct GameScoresView: View {
    @Environment(GameDetailsVM.self) private var detailsVM
    
    let game: Game
    @Binding var animation: Bool
    
    @State private var showAddScore = false
    
    @State private var displayedPoints = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    if detailsVM.verifiedScores.count > 1 {
                        Chart {
                            ForEach(detailsVM.verifiedScores.prefix(displayedPoints)) { score in
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
                        .padding(5)
                    } else {
                        CustomUnavailableView(title: "Chart unavailable", image: "chart.xyaxis.line",
                                              description: "You need 2 or more scores to see the chart")
                    }
                }
                .frame(height: 220)
                
                VStack {
                    GameDetailsLabel(showAction: $showAddScore, title: "Your scores") {
                        Label {
                            Text("Add new Score")
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
                .opacity(animation || detailsVM.verifiedScores.count < 2 ? 1.0 : 0.0)
            }
        }
        .onAppear {
            if !animation {
                chartAnimation()
            } else {
                displayedPoints = detailsVM.verifiedScores.count
            }
        }
        .sheet(isPresented: $showAddScore) {
           AddScoreView(game: game)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
    
    private func chartAnimation() {
        displayedPoints = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if displayedPoints < detailsVM.verifiedScores.count {
                withAnimation(.easeInOut(duration: 0.5)) {
                    displayedPoints += 1
                }
            } else {
                timer?.invalidate()
                withAnimation(.easeOut){
                    animation = true
                }
            }
        }
    }
}

#Preview {
    GameScoresView(game: .test, animation: .constant(true))
        .environment(UserVM(interactor: TestInteractor()))
        .environment(GamesVM(interactor: TestInteractor()))
        .environment(GameDetailsVM(interactor: TestInteractor()))
        .preferredColorScheme(.dark)
        .padding(.horizontal)
        .background(Color.background)
}

