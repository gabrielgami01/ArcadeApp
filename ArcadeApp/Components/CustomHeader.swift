import SwiftUI

struct CustomHeader: View {
    let title: String?
    
    @Environment(\.dismiss) private var dismiss
    
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, UIDevice.topInset)
        .padding(.bottom, 5)
        .background (Color.background)
    }
}

#Preview {
    CustomHeader(title: "Challenges")
        .preferredColorScheme(.dark)
}
