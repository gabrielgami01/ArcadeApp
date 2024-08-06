import SwiftUI

struct ChallengeBackCard: View {
    let challenge: Challenge
    
    var body: some View {
        let color = challenge.colorForChallenge()
        
        VStack(spacing: 5){
            Text(challenge.description)
                .font(.customFootnote)
        }
        .frame(width: 130, height: 150, alignment: .top)
        .padding()
        .customCard(borderColor: color, cornerRadius: 50)
    }
}

#Preview {
    ChallengeBackCard(challenge: .test)
}
