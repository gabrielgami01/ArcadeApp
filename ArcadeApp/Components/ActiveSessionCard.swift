import SwiftUI

struct ActiveSessionCard: View {
    @Environment(GamesVM.self) private var gamesVM
    @Environment(SessionVM.self) private var gameSessionVM
    
    @Binding var activeNamespace: Namespace.ID?
    
    @Environment(\.namespace) private var namespace
    
    var body: some View {
        if let activeSession = gameSessionVM.activeSession {
            VStack(alignment: .leading, spacing: 5) {
                Text("NOW PLAYING")
                    .font(.customTitle3)
                    .padding(.horizontal)
                
                HStack(alignment: .top, spacing: 10) {
                    Button {
                        activeNamespace = namespace
                        withAnimation {
                            gamesVM.selectedGame = activeSession.game
                        }
                    } label: {
                        GameCover(game: activeSession.game, width: 80, height: 120)
                    }
                    
                    VStack(spacing: 40) {
                        if let namespace {
                            Text(activeSession.game.name)
                                .font(.customTitle)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .multilineTextAlignment(.center)
                                .offset(y: 20)
                                .matchedGeometryEffect(id: "\(activeSession.game.id)_NAME", in: namespace, properties: .position)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
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
    ActiveSessionCard(activeNamespace: .constant(nil))
        .environment(GamesVM(repository: TestRepository()))
        .environment(SessionVM(repository: TestRepository()))
        .preferredColorScheme(.dark)
}
