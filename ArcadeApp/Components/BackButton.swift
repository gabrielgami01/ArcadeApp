import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
           action()
        } label: {
            Text("<")
                .font(.customLargeTitle)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BackButton() {
        
    }
    .preferredColorScheme(.dark)
}
