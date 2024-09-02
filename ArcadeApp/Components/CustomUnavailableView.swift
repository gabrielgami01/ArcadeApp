import SwiftUI

struct CustomUnavailableView: View {
    let title: String
    let image: String
    let description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.gray)
                .frame(width: 100)
            
            VStack{
                Text(title)
                    .font(.customTitle)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.customBody)
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    CustomUnavailableView(title: "No games", image: "gamecontroller", description: "There's no games with the name you introduced.")
        .preferredColorScheme(.dark)
}
