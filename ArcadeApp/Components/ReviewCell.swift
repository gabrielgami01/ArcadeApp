import SwiftUI

struct ReviewCell: View {
    let review: Review
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            if let avatar = review.avatarURL {
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            VStack(alignment: .leading) {
                Text(review.username)
                    .font(.customHeadline)
                HStack(spacing: 20) {
                    RatingComponent(rating: .constant(review.rating), mode: .display)
                    Text(review.date.formatted())
                        .font(.customFootnote)
                }
                .padding(.bottom, 2)
                Text(review.title)
                    .font(.customHeadline)
                   if let comment = review.comment {
                    Text(comment)
                        .font(.customSubheadline)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.cardColor)
        }
        
    }
}


#Preview {
    ReviewCell(review: .test)
}
