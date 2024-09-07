import SwiftUI

struct PageButton: View {
    @Binding var selectedPage: HomePage?
    let page: HomePage
    
    var body: some View {
        NavigationLink(value: page) {
            VStack(spacing: 10) {
                Image(systemName: page.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(15)
                    .background(page.color.opacity(0.5))
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(page.color, lineWidth: 2)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                    }
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                
                Text(page.rawValue.capitalized)
                    .font(.customCallout)
                    .foregroundColor(page.color)
                    .shadow(color: .black, radius: 1, x: 1, y: 1)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(page.color, lineWidth: 4)
                    }
            }
            .shadow(color: page.color.opacity(0.6), radius: 5)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    PageButton(selectedPage: .constant(.challenges), page: .challenges)
        .preferredColorScheme(.dark)
}
