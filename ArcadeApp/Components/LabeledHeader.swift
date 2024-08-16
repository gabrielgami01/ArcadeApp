import SwiftUI

struct LabeledHeader: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 20) {
            BackButton {
                dismiss()
            }
            Text(title)
                .font(.customLargeTitle)
        }
    }
}

#Preview {
    LabeledHeader(title: "Challenges")
}
