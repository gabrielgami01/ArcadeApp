import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Text("<")
                .font(.customLargeTitle)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BackButton()
    .preferredColorScheme(.dark)
}
