import SwiftUI

struct HomePageCard: View {
    let page: HomePage
    let image: String
    let color: Color
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color.gradient.opacity(0.7))
                .frame(width: 100, height: 100)
                .overlay {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                }
            Text(page.rawValue)
                .font(.footnote)
                .bold()
        }
    }
}

#Preview {
    HomePageCard(page: .score, image: "plus", color: .cyan)
}
