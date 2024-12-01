import SwiftUI

struct ReviewCell: View {
    let review: Review
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            UserAvatarImage(imageData: review.user.avatarImage, size: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(review.user.username)
                        .font(.customHeadline)
                    Spacer()
                    Text(review.date.formatted())
                        .font(.customFootnote)
                }
                
                RatingComponent(rating: .constant(review.rating), mode: .display)
                
                VStack(alignment: .leading) {
                    Text(review.title)
                        .font(.customHeadline)
                    if let comment = review.comment {
                        Text(comment)
                            .font(.customSubheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
    }
}


#Preview {
    ReviewCell(review: .test)
        .padding()
        .preferredColorScheme(.dark)
}
