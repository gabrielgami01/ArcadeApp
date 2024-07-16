import SwiftUI

enum RatingMode {
    case display
    case rate
}

struct RatingComponent: View {
    @Binding var rating: Int
    let mode: RatingMode
    
    let maxRating = 5
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(1 ... maxRating, id: \.self) { number in
                switch mode {
                    case .display:
                        image(for: number)
                            .foregroundStyle(number > rating ? Color.blue : Color.yellow)
                            .animation(.easeInOut(duration: 0.5).delay(Double(number) * 0.1), value: rating)
                    case .rate:
                        Button {
                            withAnimation {
                                rating = number
                            }
                        } label: {
                            image(for: number)
                                .foregroundStyle(number > rating ? Color.blue : Color.yellow)
                                .animation(.easeInOut(duration: 0.5).delay(Double(number) * 0.1), value: rating)
                        }
                        .buttonStyle(.plain)
                }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            Image(systemName: "star")
        } else {
            Image(systemName: "star.fill")
        }
    }
}

#Preview {
    RatingComponent(rating: .constant(3), mode: .rate)
}
