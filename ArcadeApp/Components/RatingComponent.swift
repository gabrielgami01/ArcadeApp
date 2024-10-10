import SwiftUI

struct RatingComponent: View {
    @Binding var rating: Int
    let mode: RatingMode
    let maxRating = 5
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(1...maxRating, id: \.self) { number in
                image(for: number)
                    .font(.callout)
                    .foregroundStyle(number > rating ? Color.gray : Color.yellow)
                    .onTapGesture {
                        if mode == .rate {
                            rating = number
                        }
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        Image(systemName: number > rating ? "star" : "star.fill")
    }
}

#Preview {
    RatingComponent(rating: .constant(3), mode: .rate)
        .preferredColorScheme(.dark)
}
