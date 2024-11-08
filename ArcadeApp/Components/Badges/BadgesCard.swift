import SwiftUI

struct BadgesCard<T: View>: View {
    let badges: [Badge]
    let featuredBadge: (Badge) -> T
    let emptyBadge: (Int) -> T

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(badges.enumerated()), id: \.element.id) { index, badge in
                featuredBadge(badge)

                if index != badges.count - 1 || badges.count < 3 {
                    Spacer()
                }
            }

            ForEach(0..<max(0, 3 - badges.count), id: \.self) { index in
                emptyBadge(index)

                if index != max(0, 3 - badges.count) - 1 {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    BadgesCard(badges: [.test2, .test3]) { badge in
        BadgeCard(type: .display, badge: badge)
    } emptyBadge: { index in
        BadgeCard(type: .add)
    }
    .preferredColorScheme(.dark)
    .padding()
    .background(Color.card)
}
