import SwiftUI

struct ScoreCell: View {
    let score: Score
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(score.date.formatted(date: .numeric, time: .shortened))
                    .font(.customBody)
                
                Spacer()
                
                HStack {
                    Text(LocalizedStringKey(score.status.rawValue.capitalized))
                        .font(.customFootnote)
                    
                    switch score.status {
                        case .verified:
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                                .font(.customFootnote)
                        case .unverified:
                            Image(systemName: "clock.badge.questionmark")
                                .font(.customFootnote)
                        case .denied:
                            Image(systemName: "xmark")
                                .foregroundStyle(.red)
                                .font(.customFootnote)
                    }
                }
            }
            if let score = score.score {
                Text("Score: \(score)")
                    .font(.customBody)
            }
        }
        .padding()
        .background(Color.card, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    ScoreCell(score: .test)
        .preferredColorScheme(.dark)
}
