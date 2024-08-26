import SwiftUI

struct RankingScoreCell: View {
    let index: Int
    let rankingScore: RankingScore
    
    var body: some View {
        HStack(spacing: 20) {
            Text("\(index + 1)")
                .font(.customHeadline)
                .foregroundColor(.gray)
            
            UserAvatarImage(imageData: rankingScore.avatarImage, height: 50, width: 50)
            
            VStack(alignment: .leading) {
                Text(rankingScore.user)
                    .font(.customTitle2)
                Text(rankingScore.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.customFootnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(rankingScore.score)")
                .font(.customTitle3)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.cardColor)
        }
    }
}

#Preview {
    RankingScoreCell(index: 1, rankingScore: .test)
        .padding()
}
