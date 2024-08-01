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
                    Text(score.state.rawValue.capitalized)
                        .font(.customFootnote)
                    Image(systemName: score.state == .verified ? "checkmark" : "xmark")
                        .foregroundStyle(score.state == .verified ? .green : .red)
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
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(white: 0.15))
        }
    }
}

#Preview {
    ScoreCell(score: .test2)
        .padding()
}
