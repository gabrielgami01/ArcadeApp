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
                            .frame(height: 220)
                        }
                    } else {
                        TimerCard(gameID: game.id)
                    }
                }
                .opacity(animation ? 1.0: 0.0)
                .animation(.easeInOut, value: animation)
                
                VStack(alignment: .leading) {
                    Text("Your past sessions")
                        .font(.customTitle3)
                    
                    if !detailsVM.sessions.isEmpty {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(detailsVM.sessions) { session in
                                SessionCard(session: session)
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
    }
}

#Preview {
    GameSessionView(game: .test, animation: .constant(true))
        .environment(GameDetailsVM(repository: TestRepository()))
        .environment(GameSessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
}
