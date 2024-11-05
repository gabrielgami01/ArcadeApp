import SwiftUI

struct RankingScoreCell: View {
    let rankingScore: RankingScore
    let index: Int
    
    var body: some View {
        HStack(spacing: 20) {
            Text("\(index + 1)")
                .font(.customHeadline)
                .foregroundColor(.secondary)
            
            UserAvatarImage(imageData: rankingScore.user.avatarImage, size: 60)
                .overlay {
                    if index == 0 {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.yellow)
                            .offset(y: -40)
                    }
                }
            
            VStack(alignment: .leading) {
                Text(rankingScore.user.username)
                    .font(.customTitle2)
                Text(rankingScore.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.customFootnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(rankingScore.score)")
                .font(.customTitle3)
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    RankingScoreCell(rankingScore: .test, index: 0)
        .preferredColorScheme(.dark)
        .padding()
}
