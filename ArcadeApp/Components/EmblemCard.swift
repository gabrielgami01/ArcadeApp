import SwiftUI

struct EmblemCard: View {
    let emblem: Emblem?
    
    var body: some View {
        VStack {
            Group {
                if let emblem {
                    Text(emblem.name) 
                } else {
                    Text("No emblem")
                }
            }
            .font(.customFootnote)
            .foregroundStyle(.secondary)
            .lineLimit(2, reservesSpace: true)
            .multilineTextAlignment(.center)
            .frame(width: 100)
            
            Image(systemName: "trophy")
                .resizable()
                .symbolVariant(.fill)
                .scaledToFit()
                .frame(height: 75)
        }
    }
}

#Preview {
    EmblemCard(emblem: .test)
        .preferredColorScheme(.dark)
}
