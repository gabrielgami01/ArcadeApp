import SwiftUI

struct ChallengeBackCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(spacing: 5){
            Text(challenge.description)
                .font(.customFootnote)
        }
        .frame(width: 130, height: 150, alignment: .top)
        .padding()
        .customCard(borderColor: challenge.colorForChallenge(), cornerRadius: 50)
    }
}

#Preview {
    ChallengeBackCard(challenge: .test)
        .preferredColorScheme(.dark)
}
