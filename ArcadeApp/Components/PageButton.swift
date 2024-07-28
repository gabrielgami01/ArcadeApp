import SwiftUI

struct PageButton: View {
    @Binding var state: Bool
    let page: HomePage
    let image: String
    let color: Color
    
    var body: some View {
        VStack {
            Button {
                state.toggle()
            } label: {
                Image(systemName: image)
                    .font(.largeTitle)
                    .padding(20)
                    .frame(width: 80)
            }
            .tint(color.gradient)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 20))
            .shimmerEffect()
            
            Text(page.rawValue)
                .font(.footnote)
                .bold()
                
        }
    }
}

#Preview {
    PageButton(state: .constant(false), page: .challenges, image: "trophy", color: .cyan)
}
