import SwiftUI

struct ChallengeFrontCard: View {
    let challenge: Challenge
    
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
                .shimmerEffect(active: true)
        }
        .frame(width: 130, height: 150)
        .padding()
        .customCard(borderColor: color, cornerRadius: 50)
        .overlay(alignment: .topTrailing) {
            if challenge.completed {
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
    ChallengeFrontCard(challenge: .test)
}
