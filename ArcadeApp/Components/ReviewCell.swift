import SwiftUI

struct ReviewCell: View {
    let review: Review
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            UserAvatarImage(imageData: review.avatarImage, height: 60, width: 60)
            
            VStack(alignment: .leading) {
                Text(review.username)
                    .font(.customHeadline)
                
                HStack(spacing: 20) {
                    RatingComponent(rating: .constant(review.rating), mode: .display)
                    Text(review.date.formatted())
                        .font(.customFootnote)
                }
                
                Text(review.title)
                    .font(.customHeadline)
                
                if let comment = review.comment {
                    Text(comment)
                        .font(.customSubheadline)
                        .foregroundStyle(.secondary)
                }
                
            }
        }
        .padding()
        .background(.card, in: .rect(cornerRadius: 10))
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    ReviewCell(review: .test)
        .preferredColorScheme(.dark)
}
