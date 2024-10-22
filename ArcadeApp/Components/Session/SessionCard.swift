import SwiftUI

struct SessionCard: View {
    let session: GameSession
    
    var body: some View {
        VStack(spacing: 10) {
            if let end = session.end {
                Text(Int(end.timeIntervalSince(session.start)).toDisplayString())
                    .font(.customLargeTitle)
                
                Text(session.start.formatted(date: .abbreviated, time: .omitted))
                    .font(.customHeadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 40) {
                    Text("Start: \(session.start.formatted(date: .omitted, time: .shortened))")
                    Text("End: \(end.formatted(date: .omitted, time: .shortened))")
                }
                .font(.customSubheadline)
                .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.card, in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SessionCard(session: .test2)
}
