import SwiftUI

struct PageButton: View {
    @Binding var selectedPage: HomePage?
    let page: HomePage
    let image: String
    let color: Color
    
    var body: some View {
        NavigationLink(value: page) {
            VStack(spacing: 10) {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(15)
                    .background(color.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(color, lineWidth: 2)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                    )
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                Text(page.rawValue)
                    .font(.customCallout)
                    .foregroundColor(color)
                    .shadow(color: .black, radius: 1, x: 1, y: 1)
            }
            .padding()
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 0.15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(color, lineWidth: 4)
                        }
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color, lineWidth: 4)
                        .blur(radius: 5)
                }
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    PageButton(selectedPage: .constant(.challenges), page: .challenges, image: "trophy", color: .green)
}
