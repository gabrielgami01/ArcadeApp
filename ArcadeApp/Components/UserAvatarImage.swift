import SwiftUI

struct UserAvatarImage: View {
    let imageData: Data?
    var size: CGFloat = 100
    
    var body: some View {
        if let avatar = imageData {
            if let image = UIImage(data: avatar) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}

#Preview {
    UserAvatarImage(imageData: nil)
        .preferredColorScheme(.dark)
}
