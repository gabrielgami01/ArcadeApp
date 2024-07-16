import SwiftUI

struct GameInfoCard: View {
    let game: Game
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                Text(game.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: "\(game.id)-name", in: namespace)
                HStack (spacing: 10){
                    Text(game.console.rawValue)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primary)
                        }
                    Text(game.genre.rawValue)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primary)
                        }
                }
                
                Text(game.description)
                    .font(.caption2)
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    GameInfoCard(game: .test, namespace: Namespace().wrappedValue)
}
