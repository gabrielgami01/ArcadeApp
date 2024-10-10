import SwiftUI

fileprivate struct SheetToolbar: ViewModifier {
    let title: LocalizedStringKey
    let confirmationLabel: LocalizedStringKey?
    let confirmationAction: (() async -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.customTitle3)
                        .padding(.bottom, 5)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.customTitle3)
                    }
                    .padding(.bottom, 5)
                }
                
                if let confirmationLabel,
                   let confirmationAction {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            Task { await confirmationAction() }
                        } label: {
                            Text(confirmationLabel)
                                .font(.customTitle3)
                        }
                        .padding(.bottom, 5)
                    }
                }
            }
    }
}

extension View {
    func sheetToolbar(title: LocalizedStringKey, confirmationLabel: LocalizedStringKey?, confirmationAction: (() async -> Void)?) -> some View {
        modifier(SheetToolbar(title: title, confirmationLabel: confirmationLabel, confirmationAction: confirmationAction))
    }
}
