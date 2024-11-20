import SwiftUI

fileprivate struct UnavailableNetwork: ViewModifier {
    let status: NetworkStatus.Status
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    CustomUnavailableView(title: "Network not available", image: "network.slash",
                                          description: "There's no internet connection at this moment. This app needs connection in order to work.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .opacity(status == .online ? 0.0 : 1.0)
            }
            .animation(.default, value: status)
    }
}

extension View {
    func unavailableNetwork(status: NetworkStatus.Status) -> some View {
        modifier(UnavailableNetwork(status: status))
    }
}
