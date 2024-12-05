import SwiftUI

struct GameSessionView: View {
    @Environment(SessionVM.self) private var gameSessionVM
    
    let game: Game
    let animation: Bool
    @State var detailsVM: GameDetailsVM
    
    var body: some View {
        @Bindable var gameSessionBVM = gameSessionVM
        
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    if let activeSession = gameSessionVM.activeSession {
                        if activeSession.game.id == game.id {
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
                .animation(.default.delay(0.4), value: animation)
            }
            .padding(.horizontal)
        }
        .errorAlert(show: $gameSessionBVM.showError)
    }
}

#Preview {
    GameSessionView(game: .test, animation: true, detailsVM: GameDetailsVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
        .background(Color.background)
        .scrollBounceBehavior(.basedOnSize)
}
