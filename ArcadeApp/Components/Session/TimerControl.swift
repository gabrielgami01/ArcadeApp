import SwiftUI

struct TimerControl: View {
    let image: String
    var size: ControlSize = .large
    var font: Font = .customHeadline
    let action: () -> Void
    
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .font(font)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .controlSize(size)
    }
}

#Preview {
    TimerControl(image: "play.fill") {}
        .preferredColorScheme(.dark)
}
