import SwiftUI

struct BadgeCard: View {
    var type: BadgeType
    var badge: Badge? = nil
    
    var body: some View {
        VStack {
            Group {
                switch type {
                    case .add:
                        Text("Add badge")
                    case .display:
                        Text(badge?.name ?? "Empty")
                    case .empty:
                        Text("Empty")
                }
            }
            .font(.customFootnote)
            .foregroundStyle(.secondary)
            .lineLimit(2, reservesSpace: true)
            .multilineTextAlignment(.center)
            .frame(width: 100)
            
            Group {
                switch type {
                    case .add:
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                    case .display:
                        Image(systemName: "trophy.fill")
                            .resizable()
                    case .empty:
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                }
            }
            .scaledToFit()
            .frame(height: 75)
                            
                        
        }
    }
}

#Preview {
    BadgeCard(type: .display, badge: .test)
        .preferredColorScheme(.dark)
}

