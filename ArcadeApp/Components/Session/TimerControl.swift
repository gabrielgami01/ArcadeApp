import SwiftUI

struct TimerControl: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .font(.customHeadline)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .controlSize(.large)
    }
}

#Preview {
    TimerControl(image: "play.fill") {}
        .preferredColorScheme(.dark)
}
