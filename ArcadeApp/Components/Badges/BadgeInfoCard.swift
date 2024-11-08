import SwiftUI

struct BadgeInfoCard: View {
    let badge: Badge
    
    var body: some View {
        VStack {
            Text(badge.name)
                .font(.customHeadline)
                .multilineTextAlignment(.center)
            
            Text(badge.game)
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
        .customCard(borderColor: badge.challengeType.colorForChallengeType(), cornerRadius: 50)
    }
}

#Preview {
    BadgeInfoCard(badge: .test)
        .preferredColorScheme(.dark)
}
