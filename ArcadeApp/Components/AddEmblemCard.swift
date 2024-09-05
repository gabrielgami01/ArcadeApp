import SwiftUI

struct AddEmblemCard: View {
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

#Preview {
    AddEmblemCard()
        .preferredColorScheme(.dark)
}
