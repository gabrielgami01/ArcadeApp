import SwiftUI

fileprivate struct HeaderToolbar: ViewModifier {
    let title: String
    
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(alignment: .firstTextBaseline, spacing: 20) {
                        BackButton {
                           dismiss()
                        }
                        
                        Text(title)
                            .font(.customLargeTitle)
                    }
                    .padding(.bottom, 5)
                }
            }
            .toolbarBackground(Color.background, for: .navigationBar)
            .navigationBarBackButtonHidden()
    }
}

extension View {
    func headerToolbar(title: String) -> some View {
        modifier(HeaderToolbar(title: title))
    }
}
