import SwiftUI

struct CustomButton: View {
    let label: String
    let actions: () -> Void
    
    var body: some View {
        Button {
            actions()
        } label: {
            Text(label)
                .font(.customHeadline)
                .bold()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            
        }
        .padding()
        .tint(.accent)
        .controlSize(.extraLarge)
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    CustomButton(label: "Login", actions: {})
}
