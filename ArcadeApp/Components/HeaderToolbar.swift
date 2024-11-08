import SwiftUI

fileprivate struct HeaderToolbar: ViewModifier {
    let title: LocalizedStringKey
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(alignment: .firstTextBaseline, spacing: 15) {
                        BackButton()
                        
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
    func headerToolbar(title: LocalizedStringKey) -> some View {
        modifier(HeaderToolbar(title: title))
    }
}
