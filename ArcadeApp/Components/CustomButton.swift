import SwiftUI

struct CustomButton: View {
    let label: String
    let actions: () -> Void
    
    var body: some View {
        Button {
            actions()
        } label: {
            Text(label)
                .font(.headline)
                .bold()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            
        }
        .padding()
        .background(.cyan, in: Capsule())
        .controlSize(.extraLarge)
        .buttonStyle(.plain)
    }
}

#Preview {
    CustomButton(label: "Login", actions: {})
        .safeAreaPadding()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
