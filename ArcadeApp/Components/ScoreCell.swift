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
                    Image(systemName: score.status == .verified ? "checkmark" : "xmark")
                        .foregroundStyle(score.status == .verified ? .green : .red)
                        .font(.customFootnote)
                }
            }
            if let score = score.score {
                Text("Score: \(score)")
                    .font(.customBody)
                    .bold()
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
