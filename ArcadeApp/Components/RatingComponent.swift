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
        HStack {
            ForEach(1 ... maxRating, id: \.self) { number in
                switch mode {
                    case .display:
                        image(for: number)
                            .foregroundStyle(number > rating ? .blue : .yellow)
                    case .rate:
                        Button {
                            rating = number
                        } label: {
                            image(for: number)
                                .foregroundStyle(number > rating ? .blue : .yellow)
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
