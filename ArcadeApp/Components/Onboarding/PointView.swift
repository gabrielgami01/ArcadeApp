import SwiftUI

struct PointView: View {
    let symbol: String
    let title: LocalizedStringKey
    let subTitle: LocalizedStringKey
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(.accent)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.customTitle3)
                
                Text(subTitle)
                    .font(.customBody)
                    .foregroundStyle(.gray)
            }
        }
    }
}
