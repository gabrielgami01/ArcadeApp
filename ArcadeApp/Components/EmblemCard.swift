import SwiftUI

struct EmblemPlaceholder: View {
    @Binding var showAddEmblem: Bool
    
    var body: some View {
        VStack {
            Text("Add new emblem")
                .font(.customFootnote)
                .foregroundStyle(.secondary)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
            
            Image(systemName: "plus.circle")
                .resizable()
                .symbolVariant(.fill)
                .scaledToFit()
                .frame(height: 75)
        }
    }
}

struct EmblemCard: View {
    let emblem: Emblem
    
    var body: some View {
        VStack {
            Text(emblem.name)
                .font(.customFootnote)
                .foregroundStyle(.secondary)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
            
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
}
