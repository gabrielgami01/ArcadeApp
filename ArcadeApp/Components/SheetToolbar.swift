import SwiftUI

fileprivate struct SheetToolbar: ViewModifier {
    let title: String
    let confirmationLabel: String?
    let confirmationAction: (() -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.customTitle3)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.customTitle3)
                    }
                }
                
                if let confirmationLabel,
                   let confirmationAction {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            confirmationAction()
                        } label: {
                            Text(confirmationLabel)
                                .font(.customTitle3)
                        }
                    }
                }
            }
    }
}

extension View {
    func sheetToolbar(title: String, confirmationLabel: String?, confirmationAction: (() -> Void)?) -> some View {
        modifier(SheetToolbar(title: title, confirmationLabel: confirmationLabel, confirmationAction: confirmationAction))
    }
}
