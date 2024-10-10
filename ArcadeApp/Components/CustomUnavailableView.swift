import SwiftUI

struct CustomUnavailableView: View {
    let title: LocalizedStringKey
    let image: String
    let description: LocalizedStringKey
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray)
                .frame(width: 100)
            
            VStack {
                Text(title)
                    .font(.customTitle)
                
                Text(description)
                    .font(.customBody)
                    .foregroundStyle(.gray)
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    CustomUnavailableView(title: "No games", image: "gamecontroller", description: "There's no games with the name you introduced.")
        .preferredColorScheme(.dark)
}
