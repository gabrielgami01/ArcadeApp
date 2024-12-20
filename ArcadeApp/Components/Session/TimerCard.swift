import SwiftUI

struct TimerCard: View {
    @Environment(SessionVM.self) private var gameSessionVM
    
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
                            await gameSessionVM.getActiveSession()
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

#Preview {
    TimerCard(gameID: Game.test.id)
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
