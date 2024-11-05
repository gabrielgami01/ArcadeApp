import SwiftUI

struct ChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text(challenge.name)
                    .font(.customHeadline)
                    .multilineTextAlignment(.center)
                
                Text(challenge.game)
                    .font(.customSubheadline)
                    .foregroundStyle(.secondary)
            }
            
            Text(challenge.description)
                .font(.customFootnote)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140, height: 140, alignment: .top)
        .padding()
        .customCard(borderColor: challenge.type.colorForChallengeType(), cornerRadius: 25)
        .overlay(alignment: .topTrailing) {
            if challenge.isCompleted {
                Image(systemName: "checkmark")
                    .symbolVariant(.circle)
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .offset(x: 10, y: -10)
            }
                            
        }
        
    }
}


#Preview {
    ChallengeCard(challenge: .test)
        .preferredColorScheme(.dark)
}
