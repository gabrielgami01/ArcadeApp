import SwiftUI

fileprivate struct HeaderToolbar: ViewModifier {
    let title: String
    let namespace: Namespace.ID?
    let backAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(alignment: .firstTextBaseline, spacing: 20) {
                        BackButton {
                            backAction()
                        }
                        if let namespace {
                            Text(title)
                                .font(.customLargeTitle)
                                .matchedGeometryEffect(id: "\(title)", in: namespace, properties: .position)
                        } else {
                            Text(title)
                                .font(.customLargeTitle)
                        }
                    }
                }
            }
            .toolbarBackground(Color.background, for: .navigationBar)
            .navigationBarBackButtonHidden()
    }
}

extension View {
    func headerToolbar(title: String, namespace: Namespace.ID? = nil, backAction: @escaping () -> Void) -> some View {
        modifier(HeaderToolbar(title: title, namespace: namespace, backAction: backAction))
    }
}
