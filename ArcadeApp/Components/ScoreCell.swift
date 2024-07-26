import SwiftUI

struct ScoreCell: View {
    let score: Score
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(score.date.formatted(date: .numeric, time: .shortened))
                    .font(.body)
                Spacer()
                HStack {
                    Text(score.state.rawValue.capitalized)
                        .font(.footnote)
                    Image(systemName: score.state == .verified ? "checkmark" : "xmark")
                        .foregroundStyle(score.state == .verified ? .green : .red)
                        .font(.footnote)
                }
            }
            if let score = score.score {
                Text("Score: \(score)")
                    .font(.body)
                    .bold()
            }
        }
    }
}

#Preview {
    ScoreCell(score: .test2)
        .padding()
}
