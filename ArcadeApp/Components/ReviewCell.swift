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
                    .font(.headline)
                HStack(spacing: 20) {
                    RatingComponent(rating: .constant(review.rating), mode: .display)
                    Text(review.date.formatted())
                        .font(.footnote)
                }
                .padding(.bottom, 2)
                Text(review.title)
                    .font(.headline)
                   if let comment = review.comment {
                    Text(comment)
                        .font(.subheadline)
                }
            }
        }
    }
}


#Preview {
    ReviewCell(review: .test)
}
