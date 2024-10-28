import SwiftUI

struct ActiveSessionCard: View {
    @Environment(SessionVM.self) private var gameSessionVM
    
    var body: some View {
        if let activeSession = gameSessionVM.activeSession {
            VStack(alignment: .leading, spacing: 5) {
                Text("NOW PLAYING")
                    .font(.customTitle3)
                    .padding(.horizontal)
                
                HStack(alignment: .top, spacing: 10) {
                    GameCover(game: activeSession.game, width: 80, height: 120)
                        .namespace(nil)
                    
                    VStack(spacing: 40){
                        Text(activeSession.game.name)
                            .font(.customTitle)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: 20)
                        
                        HStack {
                            Text(gameSessionVM.sessionDuration.toDisplayString())
                                .font(.customTitle2)
                                .bold()
                                .contentTransition(.numericText())
                                .animation(.linear, value: gameSessionVM.sessionDuration)
                            
                            Spacer()
                            
                            TimerControl(image: "stop.fill", size: .regular, font: .customFootnote) {
                                Task {
                                    if await gameSessionVM.endSessionAPI() {
                                        gameSessionVM.endSession()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ActiveSessionCard()
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
