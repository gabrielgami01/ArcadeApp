import SwiftUI

struct GameSessionView: View {
    @Environment(GameDetailsVM.self) private var detailsVM
    @Environment(GameSessionVM.self) private var gameSessionVM
    
    let game: Game
    @Binding var animation: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    if let activeSession = gameSessionVM.activeSession {
                        if activeSession.gameID == game.id {
                            TimerCard(gameID: game.id)
                        } else {
                            CustomUnavailableView(title: "Active session", image: "play.slash.fill",
                                                  description: "You already have an active session.")
                        }
                    } else {
                        TimerCard(gameID: game.id)
                    }
                }
                .opacity(animation ? 1.0: 0.0)
                .animation(.easeInOut, value: animation)
                .frame(height: 220)
                
                VStack(alignment: .leading) {
                    Text("Your past sessions")
                        .font(.customTitle3)
                    
                    if !detailsVM.sessions.isEmpty {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(detailsVM.sessions) { session in
                                VStack(spacing: 10) {
                                    if let end = session.end {
                                        Text(Int(end.timeIntervalSince(session.start)).toDisplayString())
                                            .font(.customLargeTitle)
                                        
                                        Text(session.start.formatted(date: .abbreviated, time: .omitted))
                                            .font(.customHeadline)
                                            .foregroundColor(.secondary)
                                        
                                        HStack(spacing: 40) {
                                            Text("Start: \(session.start.formatted(date: .omitted, time: .shortened))")
                                            Text("End: \(end.formatted(date: .omitted, time: .shortened))")
                                        }
                                        .font(.customSubheadline)
                                        .foregroundStyle(.secondary)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    } else {
                        CustomUnavailableView(title: "No sessions", image: "gamecontroller",
                                              description: "You haven't any session for this game yet.")
                    }
                }
                .opacity(animation ? 1.0: 0.0)
                .animation(.easeInOut.delay(0.4), value: animation)
            }
            .padding(.horizontal)
        }
        .onAppear {
            animation = true
            print("session")
        }
        .background(Color.background)
    }
}

#Preview {
    GameSessionView(game: .test, animation: .constant(true))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(GameSessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}

struct TimerControl: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .font(.customHeadline)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .controlSize(.large)
    }
}

struct TimerCard: View {
    @Environment(GameDetailsVM.self) private var detailsVM
    @Environment(GameSessionVM.self) private var gameSessionVM
    
    let gameID: UUID
    
    var body: some View {
        VStack(spacing: 20) {
            Text(gameSessionVM.sessionDuration.toDisplayString())
                .font(.customTimerDisplay)
                .contentTransition(.numericText())
                .animation(.linear, value: gameSessionVM.sessionDuration)
            
            HStack(spacing: 20) {
                TimerControl(image: "play.fill") {
                    Task {
                        if await gameSessionVM.startSessionAPI(gameID: gameID) {
                            await gameSessionVM.getActiveGameSession()
                        }
                    }
                }
                .disabled(gameSessionVM.isTimerRunning)

                TimerControl(image: "stop.fill") {
                    Task {
                        if await gameSessionVM.endSessionAPI() {
                            gameSessionVM.endSession()
                        }
                    }
                }
                .disabled(!gameSessionVM.isTimerRunning)
            }
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
    }
}
