import SwiftUI

struct ChallengeFrontCard: View {
    let challenge: Challenge
    let showCheck: Bool
    
    var body: some View {
        let color = challenge.colorForChallenge()
        
        VStack {
            Text(challenge.name)
                .font(.customHeadline)
                .multilineTextAlignment(.center)
            
            Text(challenge.game)
                .font(.customFootnote)
                .foregroundStyle(.secondary)
            
            Image(systemName: "trophy")
                .resizable()
                .symbolVariant(.fill)
                .scaledToFit()
                .frame(height: 75)
        }
        .frame(width: 130, height: 150)
        .padding()
        .customCard(borderColor: color, cornerRadius: 50)
        .overlay(alignment: .topTrailing) {
            if showCheck {
                Image(systemName: "checkmark")
                    .symbolVariant(.circle)
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                    .offset(x: 5, y: -5)
            }
        }
    }
}

#Preview {
    ChallengeFrontCard(challenge: .test, showCheck: true)
}
