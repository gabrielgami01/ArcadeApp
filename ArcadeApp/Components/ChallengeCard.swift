import SwiftUI

struct ChallengeCard: View {
    let challenge: Challenge
    @State private var isFlipped = false
    
    var body: some View {        
        ZStack {
            ChallengeFrontCard(challenge: challenge)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 0 : 1)
            ChallengeBackCard(challenge: challenge)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isFlipped.toggle()
            }
        }
    }
}

#Preview {
    ChallengeCard(challenge: .test)
}
