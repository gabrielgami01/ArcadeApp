import SwiftUI

struct BackButton: View {
    var action: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            if let action {
                action()
            } else {
                dismiss()
            }
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
