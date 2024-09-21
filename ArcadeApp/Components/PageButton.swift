import SwiftUI

struct PageButton: View {
    let page: HomePage
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: page.image)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(15)
                .background(.accent.opacity(0.5))
                .overlay{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.accent, lineWidth: 2)
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                }
                //.shadow(color: .black, radius: 2, x: 2, y: 2)
            
            Text(page.rawValue.capitalized)
                .font(.customCallout)
                .foregroundColor(.accent)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.accent, lineWidth: 4)
                }
        }
        .shadow(color: .accent.opacity(0.4), radius: 5)
    }
}


#Preview {
    PageButton(page: .challenges)
        .preferredColorScheme(.dark)
}
