import SwiftUI

fileprivate struct HeaderToolbar: ViewModifier {
    let title: LocalizedStringKey
    let blur: Bool
    
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
                    .blur(radius: blur ? 10 : 0)
                }
            }
            .toolbarBackground(Color.background, for: .navigationBar)
            .navigationBarBackButtonHidden()
    }
}

extension View {
    func headerToolbar(title: LocalizedStringKey, blur: Bool = false) -> some View {
        modifier(HeaderToolbar(title: title, blur: blur))
    }
}
