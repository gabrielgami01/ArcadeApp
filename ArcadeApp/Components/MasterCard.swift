import SwiftUI

struct MasterCard: View {
    let master: Master
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.quaternary)
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            .overlay(alignment: .topLeading) {
                Text(master.name)
                    .font(.callout)
                    .bold()
                    .padding()
            }
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55)
                    .padding()
            }
    }
}

#Preview {
    MasterCard(master: Console.test)
        .padding(100)
}
