import SwiftUI

struct ScoreImage: View {
    var image: UIImage?
    
    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            VStack {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(.gray)
                    }
                Text("Tap to upload an image")
                    .foregroundColor(.gray)
                    .font(.customHeadline)
                    .padding(.top, 10)
            }
            .frame(width: 300, height: 300)
        }
    }
}

#Preview {
    ScoreImage()
        .preferredColorScheme(.dark)
}
