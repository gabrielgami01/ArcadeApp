import SwiftUI

struct CustomHeader: View {
    @Environment(\.dismiss) private var dismiss
    let title: String?
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 20) {
            BackButton {
                dismiss()
            }
            if let title {
                Text(title)
                    .font(.customLargeTitle)
            }
        }
    }
}

#Preview {
    CustomHeader(title: "Challenges")
}
